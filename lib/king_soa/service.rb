module KingSoa
  class Service
    # endpoint url
    attr_accessor :debug, :name, :auth_key, :queue, :response
    attr_reader :request
    
    def initialize(opts)
      self.name = opts[:name].to_sym
      self.url = opts[:url] if opts[:url]      
      self.queue = opts[:queue] if opts[:queue]
      self.auth_key = opts[:auth_key] if opts[:auth_key]
    end

    def call_remote(*args)
      set_request_opts(args)
      resp_code = @request.perform
      case resp_code
      when 200
        #Hoth::Loggerequest.debug "response.body: #{response.body}"
        return self.decode(@request.response_body)["result"]
      else
        #Hoth::Loggerequest.debug "response.body: #{response.body}"
        return self.decode(@request.response_body)["error"]
      end
    end

    def execute(*args)
      result = local_class ? local_class.send(:execute, *args) : call_remote(*args)
      return result
    end

    def local_class
      @local_class_name ||= "#{self.name.to_s.camelize}"
      begin
        @local_class_name.constantize
      rescue NameError => e        # no local implementation
        false
      end
    end

    def request
      @request ||= Typhoeus::Easy.new
    end

    def set_request_opts(args)
      r = request
      request.url         = url
      request.method      = :post
      request.user_agent  = 'KingSoa'
      request.follow_location = true
      request.timeout     = 100 # milliseconds
      request.params      = params(args)
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

    # The params for each soa request consisnt of two values:
    # name => the name of the method to call
    # params => the parameters for the method
    # ==== Parameter
    # params<Hash|Array|String>:: will be json encoded
    # === Returns
    # <Hash{String=>String}>:: params added to the POST body
    def params(payload)
      { 'name'   => name.to_s,
        'params' => encode(payload),
        'auth_key'=> auth_key }
    end

  end
end