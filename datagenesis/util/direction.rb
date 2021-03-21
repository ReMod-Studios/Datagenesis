# frozen_string_literal: true

require 'values'

module Datagenesis
  class Direction

    def initialize(name, ordinal, opposite_ord, horizontal_ord)
      @name = name
      @ordinal = ordinal
      @opposite_ord = opposite_ord
      @horizontal_ord = horizontal_ord
    end

    DOWN  = Direction.new(:down, 0, 1, nil)
    UP    = Direction.new(:up,    1, 0, nil)
    NORTH = Direction.new(:north, 2, 3, 2)
    SOUTH = Direction.new(:south, 3, 2, 0)
    WEST  = Direction.new(:west,  4, 5, 1)
    EAST  = Direction.new(:east,  5, 4, 3)
    VALUES = [DOWN, UP, NORTH, SOUTH, EAST, WEST].freeze
    HORIZONTALS = [NORTH, SOUTH, EAST, WEST].freeze

    attr_reader :name, :ordinal, :opposite_ord, :horizontal_ord

    def self.by_id(id)
      VALUES[id]
    end

    def opposite
      Direction.by_id(@opposite_ord)
    end

    def y_rot
      @horizontal_ord & 3 * 90 unless @horizontal_ord.nil?
    end

    def to_s
      name.to_s
    end
  end
end