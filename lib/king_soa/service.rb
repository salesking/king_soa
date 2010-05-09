module KingSoa
  class Service
    # endpoint url
    attr_accessor :debug, :name, :auth, :queue
    attr_reader :request
    
    def initialize(opts)
      self.name = opts[:name].to_sym
      self.url = opts[:url] if opts[:url]      
      self.queue = opts[:queue] if opts[:queue]
      self.auth = opts[:auth] if opts[:auth]
    end

    # Call a service living somewhere in the soa universe. This is done by
    # making a POST request to the url
    def call_remote(*args)
      set_request_opts(args)
      resp_code = @request.perform
      case resp_code
      when 200
        return self.decode(@request.response_body)["result"]
      else
        return self.decode(@request.response_body)["error"]
      end
    end

    # A queued method MUST have an associated resque worker running and the soa
    # class MUST have the @queue attribute for redis set
    def add_to_queue(*args)
      # use low level resque method since class might not be local available for Resque.enqueue
      Resque::Job.create(queue, local_class_name, *args)
    end

    # Call a method: remote over http, local or put a job onto a queue
    # === Parameter
    # args:: whatever arguments the service methods recieves. Those are later json
    # encoded for remote or queued methods
    def perform(*args)
      if queue
        add_to_queue(*args)
        return nil
      else
        result = local_class ? local_class.send(:perform, *args) : call_remote(*args)
        return result
      end
    end    

    def local_class
      @local_class ||= begin
                        local_class_name.constantize
                      rescue NameError => e        # no local implementation
                        false
                      end
    end

    # Return the classname infered from service name
    def local_class_name
      self.name.to_s.camelize
    end

    def request
      @request ||= Typhoeus::Easy.new
    end

    def set_request_opts(args)
      request.url         = url
      request.method      = :post
      request.timeout     = 100 # milliseconds
      request.params      = params(args)
      request.user_agent  = 'KingSoa'
      request.follow_location = true      
      request.verbose     = 1 if debug      
    end

    # Url receiving the request
    # TODO. if not present try to grab from endpoint
    def url
      @url
    end
    def url=(url)
      @url = "#{url}/soa"
    end

    # The params for each soa request consist of following values:
    #    name => the name of the method to call
    #    args => the arguments for the soa class method
    #    auth => an authentication key. something like a api key or pass. To make
    # it really secure you MUST use https or do not expose your soa endpoints
    #
    # ==== Parameter
    # payload<Hash|Array|String>:: will be json encoded
    # === Returns
    # <Hash{String=>String}>:: params added to the POST body
    def params(payload)
      { 'name'    => name.to_s,
        'args'    => encode(payload),
        'auth'    => auth }
    end

    def encode(string)
      string.to_json
    end

    def decode(string)
      begin
        JSON.parse(string)
      rescue JSON::ParserError => e
        raise e
      end
    end

  end
end