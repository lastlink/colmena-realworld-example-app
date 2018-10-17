module Colmena
  module Cell
    module ClassMethods
      def ports
        @ports ||= []
      end

      def register_port(port)
        ports << port
      end

      def commands
        @commands ||= {}
      end

      def register_command(command)
        commands[class_to_sym(command)] = command
      end

      def queries
        @queries ||= {}
      end

      def register_query(query)
        queries[class_to_sym(query)] = query
      end

      def class_to_sym(klass)
        name_without_namespace = klass.name.split('::').last
        name_without_namespace.gsub(/([^\^])([A-Z])/,'\1_\2').downcase.to_sym
      end
    end

    def self.included(klass)
      klass.extend ClassMethods
    end

    def initialize(ports={})
      @ports = ports
      @commands = inject_ports(self.class.commands)
    end

    def port(name)
      @ports.fetch(name)
    end

    def command(name)
      @commands.fetch(name)
    end

    def commands
      @commands
    end

    def query(name)
      @queries.fetch(name)
    end

    def queries
      @queries
    end

    private

    def inject_ports(klasses)
      Hash[klasses.map { |name, klass| [name, klass.new(@ports)] }]
    end
  end
end
