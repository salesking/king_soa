require 'singleton'
require 'resque'
require 'json'
require 'typhoeus'
require 'active_support/inflector'
# Rails 3.0
#require 'active_support'
#require 'active_support/core_ext/string'

require 'king_soa/registry'
require 'king_soa/service'
require 'king_soa/rack/middleware'

module KingSoa
  
  class << self
    
    # Locate service by a given name:
    #   KingSoa.find(:my_service_name)
    # ==== Parameter
    # service<String|Symbol>:: the name to lookup
    def find(service)
      Registry[service]
    end

    # This is where the services get called.
    # Tries to locate the service in the registry and if found call its perform
    # method
    def method_missing(meth, *args, &blk) # :nodoc:
      if service = Registry[meth]
        service.perform(*args)
      else
        super(meth, *args, &blk)
      end
    end
  end

end