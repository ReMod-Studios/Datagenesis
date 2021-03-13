# frozen_string_literal: true

module Datagenesis
  # Represents a pipeline processor that
  # processes and outputs data.
  class Processor

    def initialize(namespace:, **kwargs)
      @namespace = namespace
    end

    @id_to_class = {}

    class << self
      attr_reader :id_to_class
    end

    def self.register(id)
      Processor.id_to_class[id.to_sym] = self
    end

    def self.class_for(id)
      Processor.id_to_class[id.to_sym] || raise(ArgumentError, "#{id} not found in processor registry")
    end

    def self.from_struct(struct, attributes = {})
      if struct.is_a? String
        class_for(struct).new(**attributes)
      else
        id = struct[:id]
        rest = struct.reject { |k, _| k == :id }.update attributes
        class_for(id).new(**rest)
      end
    end
  end
end
