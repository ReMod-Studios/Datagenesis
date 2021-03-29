# frozen_string_literal: true

require_relative 'direction'

module Datagenesis
  VariantPropertyValue = Struct.new :id, :name, :value

  class VariantProperty
    attr_reader :id, :name, :values

    @properties = {}

    def initialize(id, *values, name: id)
      @id = id.to_sym.freeze
      @name = name.to_sym.freeze
      @values = values.map { VariantPropertyValue.new(@id, @name, _1) }.freeze
    end

    class << self
      def property(id, *values, name: id)
        @properties[id] = Datagenesis::VariantProperty.new id, *values, name: name
      end

      def bool_property(id, name: id)
        property id, true, false, name: name
      end

      def get(id)
        @properties[id]
      end
    end

    property :facing, *Direction::VALUES
    property :horizontal_facing, *Direction::HORIZONTALS, name: :facing
    bool_property :powered
    bool_property :open
    property :block_half, *%i[top bottom], name: :half
    property :double_half, *%i[upper lower], name: :half
    property :slab_type, *%i[top bottom double], name: :type
    property :door_hinge, *%i[left right], name: :hinge
    property :axis, *%i[x y z]
  end
end
