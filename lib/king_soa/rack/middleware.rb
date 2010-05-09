module KingSoa::Rack
  class Middleware

    def initialize(app)
      @app = app
    end

    # Takes incoming soa requests and calls the passed in method with given params
    def call(env)
#      Hoth::Logger.debug "env: #{env.inspect}"
      if env["PATH_INFO"] =~ /^\/soa/
        begin
          req = Rack::Request.new(env)
          # find service
          service = KingSoa.find(req.params["name"])
          #  TODO rescue service class not found
          raise "The service: #{req.params["name"]} could not be found" unless service
          # authenticate
          authenticated?(service, req.params["auth"])
          # perform method with decoded params
          result = service.perform(*service.decode( req.params["args"] ))
          # encode result
          encoded_result = service.encode({"result" => result})
          # and return
          [
            200,
            {'Content-Type' => 'application/json', 'Content-Length' => "#{encoded_result.length}"},
            [encoded_result] 
          ]

        rescue Exception => e
          #Hoth::Logger.debug "e: #{e.message}"
          if service
            encoded_error = service.encode({"error" => e})
            [500, {'Content-Type' => 'application/json', 'Content-Length' => "#{encoded_error.length}"}, [encoded_error]]
          else
            encoded_error = {"error" => "An error occurred => #{e.message}"}.to_json
            [500, {'Content-Type' => "application/json", 'Content-Length' => "#{encoded_error.length}"}, [encoded_error]]
          end
        end
      else
        @app.call(env)
      end
    end

    # TODO raise and rescue specific error
    def authenticated?(service, key)
      raise "Please provide a valid authentication key" unless service.auth == key
    end

  end
end