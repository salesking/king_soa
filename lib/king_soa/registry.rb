module KingSoa
  class Registry
    include Singleton

    ############################################################################
    # Class methods .. only use those since we are in a Singleton
    ############################################################################

    # Get a method by a given name
    def self.[](service_name)
      instance[service_name]
    end
    # add a service
    def self.<<(service)
      instance << service
    end
    # Return an array of defined services
    def self.services
      instance.services
    end

    # find a group of services identified by starting with the same string
    #
    def self.group(name)
      instance.group(name)
    end
    ############################################################################
    # Instance methods - not directly accessible => Singleton
    ############################################################################

    # returns all available methods
    def services
      @services ||= []
    end

    # Add a new service onto the stack
    # === Parameter
    # service<KingSoa::Service>:: the service to add
    def <<(service)
      (services || []) << service
    end

    # Get a method by a given name
    # === Parameter
    # service_name<String|Symbol>:: the service to find
    # === Returns
    # <KingSoa::Service> or <nil>
    def [](service_name)
      name = service_name.to_sym
      services.detect {|s| s.name == name }
    end

    # untested
    def group(service_name)
      services.select {|s| !s.name.to_s.match(/^#{service_name}/).nil? }
    end


  end
end