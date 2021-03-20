# frozen_string_literal: true

require_relative 'util/identifier'
require_relative 'processor'
require_relative 'processors/end'

module Datagenesis
  # Represents a parsed entry to be processed by
  # the appropriate pipeline processors.
  class Entry
    attr_reader :id, :processors

    END_PROCESSOR = Datagenesis::Processors::End.new

    def initialize(id, processors, exclude_end: false)
      @id = id
      @processors = processors
      @processors << END_PROCESSOR unless exclude_end
    end

    def process
      @processors.each_cons(2) { _1.nxt = _2 }
      root_processor = @processors.first
      root_processor.process self
    end
  end
end
