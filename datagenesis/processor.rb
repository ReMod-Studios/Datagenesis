# frozen_string_literal: true

require 'set'

module Datagenesis
  # Represents a pipeline processor that
  # processes and outputs data.
  class Processor
    attr_accessor :nxt

    def initialize(**kwargs)
      self.class.attributes
    end

    def process(entry)
      forward entry
      process_end
    end

    def process_end; end

    private

    def forward(*args, **kwargs, &block)
      caller = caller_locations(1, 1)[0].label.to_sym
      @nxt&.send(caller, *args, **kwargs, &block)
    end

    @id_to_class = {}

    class << self
      def register(id)
        Processor.id_to_class[id.to_sym] = self
      end

      def class_for(id)
        Processor.id_to_class[id.to_sym] or raise ArgumentError, "#{id} not found in processor registry"
      end

      def from_struct(struct, attributes = {})
        if struct.is_a? String
          class_for(struct).new(**attributes)
        else
          id = struct[:id]
          rest = struct.except(:id).update attributes
          class_for(id).new(**rest)
        end
      end

      def processor_attr(*attributes)
        @attributes ||= ::Set.new
        @attributes.merge(attributes)
      end

      protected

      attr_reader :id_to_class, :attributes
    end
  end
end
