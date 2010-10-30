module KingSoa
  class Service

    # name<String/Symbol>:: name of the service class to call
    #
    # auth<String/Int>:: password for the remote service. Used by rack middleware
    # to authentify the callee
    #
    #
    # queue<Boolean>:: turn on queueing for this service call. The incoming
    # request(className+parameter) will be put onto a resque queue
    #
    # debug<Boolean>:: turn on verbose output for typhoeus request
    #
    # request_method<Symbol>:: :get :post, :put : delete, used for curl request
    
    attr_accessor :debug, :name, :auth, :queue, :request_method
    # raw_url<String>:: raw incoming url string with request method prefixed "GET http://whatever"
    attr_reader :raw_url
    
    def initialize(opts)
      self.name = opts[:name].to_sym
      [:url, :queue, :auth, :debug ].each do |opt|
        self.send("#{opt}=", opts[opt]) if opts[opt]
      end     
    end

    # Call a service living somewhere in the soa universe. This is done by
    # making a request(defaults to POST) to the url.
    # === Parameter
    # args<MultipleMixed>:: arguments passed to the service method. Each one MUST be json encodable
    def call_remote(*args)
      request = Typhoeus::Easy.new
      set_request_opts(request, args)
      resp_code = request.perform
      parse_response(resp_code, request)
    end

    # parse the services response
    # === Parameter
    # resp_code<Integer>::
    # request<Typhoeus::Easy>::
    # === Returns
    # <String>:: plain response body if the content type is not json
    # <Object>:: json decoded response_body if the content type is json
    # if the resonse code is 200, the response body MUST include a result object on top level
    # {result:{my stringified json object}}
    # if the resonse code NOT 200, the response body MUST include a error object on top level
    # {error:{my stringified json error}}
    def parse_response(resp_code, request)
      if request.response_header.include?('Content-Type: application/json')
        #decode incoming json carrying an error or result. most likely from KingSoa's rack middleware
        json_key = (resp_code==200) ? 'result' : 'error'
        return self.decode(request.response_body)[json_key]
      else # return plain body
        return request.response_body
      end
    end

    # A queued method MUST have an associated resque worker running and the
    # receiving soa class MUST have the @queue attribute for resque(redis) set
    # === Parameter
    # args<MultipleMixed>:: arguments passed to the queued method. Each one MUST be json encodable
    def add_to_queue(*args)
      # use low level resque method since class might not be local available for Resque.enqueue
      Resque::Job.create(queue, local_class_name, *args)
    end

    # Call a method:
    #  * remote over http
    #  * local by calling perform method on a class
    #  * put a job onto a queue
    # === Parameter
    # args:: whatever arguments the service methods receives. A local service/method
    # gets thems as splatted params. For a remote service they are converted to
    # json
    # === Returns
    # <nil> queued services dont answer
    # <mixed> Whatever the method/service returns
    def perform(*args)
      if queue
        add_to_queue(*args)
        return nil
      else # call the local class if present, else got remote
        result = local_class ? local_class.send(:perform, *args) : call_remote(*args)
        return result
      end
    end

    # The local class, if found
    # === Returns
    # <Class>:: if found in local scope
    # <False>: if no class with the name can be found
    def local_class
      begin
        local_class_name.constantize
      rescue NameError => e        # no local implementation
        false
      end
    end

    # === Returns
    # <String>:: camelized class name infered from the service name.
    # === Example
    # save_attachment => SaveAttachment
    def local_class_name
      self.name.to_s.camelize
    end

    # Set options for the typhoeus curl request
    # === Parameter
    # req<Typhoeus::Easy>:: request object
    # args<Array[Mixed]>:: arguments for the soa method. MUST be json en-/decodable
    # added to post body json encoded
    def set_request_opts(req, args)
      req.url         = url
      req.method      = request_method || :post
      req.timeout     = 10000 # milliseconds
      req.params      = params(args)
      req.user_agent  = 'KingSoa'
      req.follow_location = true
      req.verbose     = 1 if debug
    end

    #Sets the service url for remote service calls
    #=== Parameter
    #url_string<String>::service location to call.
    # 
    # POST(default)
    # http://myUrl.com
    # http://myUrl.com:3000/my_path
    # http://myUrl.com:3000/soa
    #
    # Request types can be defined within url string:
    #   GET http://myUrl.com
    #   DELETE http://myUrl.com:3000/my_path
    #   PUT http://myUrl.com:3000/soa
    #   POST http://myUrl.com:3000/custom_post_receiving_path
    # 
    # === Returns
    # url<String>:: service url
    #
    def url=(url_string)
      # grab leading req type, case-insensitive
      if req_type = url_string[/^(GET|POST|PUT|DELETE)/i, 0]
        @request_method = req_type.downcase.to_sym
      end
      @raw_url = url_string
      # grab only url string starting with ht until its end
      @url = url_string[/ht.*/i, 0]
    end

    def url
      @url
    end

    # Params for a soa request consist of following values:
    # name => name of the soa class to call
    # args => arguments for the soa class method -> Class.perform(args)
    # auth => an authentication key. something like a api key or pass. To make
    # it really secure you MUST use https or hide your soa endpoints from public 
    # web acces
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