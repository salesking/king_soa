module KingSoa
  class Registry
    include Singleton

    ############################################################################
    # Class methods .. only use those since we are in a Singleton
    ############################################################################

    # Get a method by a given name
    # see instance method for doc
    def self.[](service_name)
      instance[service_name]
    end
    # add a service
    # see instance method for doc
    def self.<<(service)
      instance << service
    end
    # Return an array of defined services
    # see instance method for doc
    def self.services
      instance.services
    end

    # find a group of services identified by starting with the same string
    # see instance method for doc
    def self.group(name)
      instance.group(name)
    end
    ############################################################################
    # Instance methods - not directly accessible => Singleton
    ############################################################################

    # get all available services methods
    # === Returns
    # <Array[KingSoa::Service]>
    def services
      @services ||= []
    end

    # Add a new service onto the stack
    # === Parameter
    # service<KingSoa::Service>:: the service to add
    def <<(service)
      (services || []) << service
    end

    # Get a service by a given name
    # === Parameter
    # service_name<String|Symbol>:: the service to find
    # === Returns
    # <KingSoa::Service> or <nil>
    def [](service_name)
      name = service_name.to_sym
      services.detect {|s| s.name == name }
    end

    # Find a group of serivces by a name .. regex checks starting of name
    # === Parameter
    # service_name<String|Symbol>:: the service to find
    # === Returns
    # <Array[KingSoa::Service]>
    def group(service_name)
      services.select {|s| !s.name.to_s.match(/^#{service_name}/).nil? }
    end

  end
end