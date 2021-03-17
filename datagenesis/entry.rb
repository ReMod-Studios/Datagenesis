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

    def process
      @processors.each do |p|
        p.process self
      end
    end
  end
end
