# frozen_string_literal: true

module Datagenesis
  # Represents a pipeline processor that
  # processes and outputs data.
  class Processor

    def initialize(**kwargs)
      # Left blank for runtime patching needs
    end

    def process(entry); end

    @id_to_class = {}

    class << self
      def register(id)
        Processor.id_to_class[id.to_sym] = self
      end

      def class_for(id)
        Processor.id_to_class[id.to_sym] || raise(ArgumentError, "#{id} not found in processor registry")
      end

      def from_struct(struct, attributes = {})
        if struct.is_a? String
          class_for(struct).new(**attributes)
        else
          id = struct[:id]
          rest = struct.reject { |k, _| k == :id }.update attributes
          class_for(id).new(**rest)
        end
      end

      def processor_attr(*names)
        init = instance_method(:initialize)

        # TODO: somehow enforce dynamic keywords onto the thing
        define_method(:initialize) do |**kwargs|
          init.bind(self).call(**kwargs)
          names.each do |n|
            instance_variable_set(:"@#{n}", kwargs.fetch(n))
          end
        end
      end

      protected

      attr_reader :id_to_class
    end

    processor_attr :namespace
  end
end
