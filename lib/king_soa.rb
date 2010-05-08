require 'singleton'
require 'json'
require 'typhoeus'
require 'active_support/inflector'

require 'king_soa/registry'
require 'king_soa/service'
require 'king_soa/rack/middleware'

# Define available services.
#
# service:
#   name: sign_document
#   url: "https://msg.salesking.eu"
#   auth: 'a-long-random-string'
#   queue: a-queue-name
#
#
# method: save_signed_document
# url: "https://www.salesking.eu/soa"
#
#
# after defining your services you can call each of them with
#
# <tt>KingSoa.service_name(args)</tt>
#
#     KingSoa.sign_document(counter)
#     current_number = Hoth::Services.value_of_counter(counter)
#     created_account = Hoth::Services.create_account(account)
#
module KingSoa
  
  class << self

    def init_from_hash(services)
      # create service      
    end
    
    # Locate service by a given name
    # ==== Parameter
    # service<String|Symbol>:: the name to lookup
    def find(service)
      Registry[service]
    end

    # this is where the services get called
    def method_missing(meth, *args, &blk) # :nodoc:
      if service = Registry[meth]
        service.perform(*args)
      else
        super
      end
    end
  end

end