module KingSoa
  class Service
    # endpoint url
    attr_accessor :debug, :name, :auth, :queue
    
    def initialize(opts)
      self.name = opts[:name].to_sym
      [:url, :queue,:auth, :debug ].each do |opt|
        self.send("#{opt}=", opts[opt]) if opts[opt]
      end     
    end

    # Call a service living somewhere in the soa universe. This is done by
    # making a POST request to the url
    def call_remote(*args)
      request = Typhoeus::Easy.new
      set_request_opts(request, args)
      resp_code = request.perform
      case resp_code
      when 200
        return self.decode(request.response_body)["result"]
      else
        return self.decode(request.response_body)["error"]
      end
    end

    # A queued method MUST have an associated resque worker running and the soa
    # class MUST have the @queue attribute for redis set
    def add_to_queue(*args)
      # use low level resque method since class might not be local available for Resque.enqueue
      Resque::Job.create(queue, local_class_name, *args)
    end

    # Call a method:
    #  * remote over http
    #  * local by calling perform method on a class
    #  * put a job onto a queue
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

    # The local class, if found
    def local_class
      begin
        local_class_name.constantize
      rescue NameError => e        # no local implementation
        false
      end
    end

    # Return the classname infered from the camelized service name.
    # A service named: save_attachment => class SaveAttachment
    def local_class_name
      self.name.to_s.camelize
    end

    # Set options for the typhoeus curl request
    # === Parameter
    # req<Typhoeus::Easy>:: request object
    # args<Array[]>:: the arguments for the soa method, will be json encoded and added to post body
    def set_request_opts(req, args)
      req.url         = url
      req.method      = :post
      req.timeout     = 10000 # milliseconds
      req.params      = params(args)
      req.user_agent  = 'KingSoa'
      req.follow_location = true
      req.verbose     = 1 if debug
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