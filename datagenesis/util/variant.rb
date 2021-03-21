# frozen_string_literal: true

require_relative 'variant_property'

module Datagenesis
  class Variant
    def initialize(property_pairs)
      @property_pairs = property_pairs.freeze || []
    end

    def [](*ids)
      @property_pairs.filter { |v| v if ids.any? v.id }
                     .sort_by { |a| ids.index(a.id) || Float::INFINITY }
                     .map(&:value)
                     .freeze
    end

    def to_s
      @property_pairs.map { |property| "#{property.name}=#{property.value}" }.join(',')
    end
  end

  class VariantFactory
    attr_reader :properties

    def initialize(*properties)
      @properties = process_input properties
      yield_self if block_given?
    end

    def build
      raise 'Missing properties!' if @properties.empty?

      values = @properties.map(&:values)
      values[0]
        .product(*values[1..])
        .map { |pairs| Variant.new(pairs) }
    end

    # Shorthand
    def self.build(*properties)
      VariantFactory.new(*properties).build
    end

    private

    def process_input(input)
      case input
      when Symbol
        VariantProperty.get(input)
      when Array
        input.flatten.map { |it| process_input it }
      else
        input
      end
    end
  end
end
