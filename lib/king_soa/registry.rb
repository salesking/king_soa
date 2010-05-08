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
    def group(name)
      instance.group(name)
    end
    ############################################################################
    # Instance methods - not directly accessible => Singleton
    ############################################################################

    # returns all available methods
    def services
      @services ||= []
    end

    # Add a new method onto the stack
    def <<(service)
      (services || []) << service
    end

    # Get a method by a given name
    def [](service_name)
      name = service_name.to_sym
      services.detect {|s| s.name == name }
    end

    def group(service_name)
      name = service_name.to_sym
#      srvs = []
      services.collect {|s| s.name[/^#{name}/] }
    end


  end
end