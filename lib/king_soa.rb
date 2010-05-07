require 'singleton'
require 'json'
require 'typhoeus'
#require 'king_hmac'
require 'active_support/inflector'

require 'king_soa/registry'
require 'king_soa/service'
require 'king_soa/rack/middleware'

# Define available services.
#
# service:
#   name: sign_document
#   url: "https://msg.salesking.eu"
#   hmac: 'key:secret'#
#   queue: a-queue-name
#
#
#
#   method: 
#     name: sign_document
#     # if given the named resque queue will be used
#     queue: signings
#
# method: save_signed_document
# url: "https://www.salesking.eu/soa"
#
#
# after defining your services you can call each of them with
# <tt>Hoth::Services.service_name(params)</tt>
#
#     KingSoa.sign_document(counter)
#     current_number = Hoth::Services.value_of_counter(counter)
#     created_account = Hoth::Services.create_account(account)
#
module KingSoa
  
  class << self

    def init_from_yaml(loc)
      
    end
    # Locate service by a given name
    # ==== Params
    # service<String|Symbol>:: the name to lookup
    def find(service)
      Registry[service]
    end
      # this is where the services get called
      def method_missing(meth, *args, &blk) # :nodoc:
        if service = Registry[meth]
          service.execute(*args)
        else
          super
        end
      end
    end

end