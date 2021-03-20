# frozen_string_literal: true

require_relative 'direction'

module Datagenesis
  VariantPropertyValue = Struct.new :name, :value

  class VariantProperty
    attr_reader :name, :values

    @properties = {}

    def initialize(name, *values)
      @name = name.to_sym.freeze
      @values = values.map { |v| VariantPropertyValue.new(@name, v) }.freeze
    end

    class << self
      def property(name, *values)
        @properties[name] = Datagenesis::VariantProperty.new name, *values
      end

      def bool_property(name)
        property name, true, false
      end

      def get(name)
        @properties[name]
      end
    end

    property :direction, *Direction::HORIZONTALS
    bool_property :powered
    bool_property :open
    property :half, *%i[upper lower]
    property :hinge, *%i[left right]
  end
end
