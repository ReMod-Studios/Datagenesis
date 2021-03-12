# frozen_string_literal: true

module Datagenesis
  # Represents a pipeline processor that
  # processes and outputs data.
  class Processor
    attr_reader :id, :attributes

    def initialize(id, attributes = {})
      @id = id
      @attributes = attributes
    end

    def self.from_struct(struct, attributes = {})
      if struct.is_a? String
        Processor.new(struct, attributes)
      else
        id = struct[:id]
        rest = struct.reject { |k, _| k == :id }.update attributes
        Processor.new(id, rest)
      end
    end
  end
end
