# frozen_string_literal: true

require_relative 'identifier'

module Datagenesis
  # Represents a parsed entry to be processed by
  # the appropriate pipeline processors.
  class Entry
    attr_reader :id, :processors

    def initialize(id, processors = [])
      @id = id
      @processors = processors
    end

    def self.from_ns_and_id(namespace, id, processors)
      Entry.new(Identifier.new(namespace, id), processors.dup)
    end
  end
end
