# frozen_string_literal: true

require 'json'
require 'fileutils'
require_relative 'entry'
require_relative 'processor'
require_relative 'util/identifier'

module Datagenesis
  # Parser for the datagenesis.yml structure
  class Parser

    SPECIAL_KEYS = %i[group contains].freeze

    def self.parse_struct(struct)
      # Default values: no attributes, root dummy processor
      Parser.new
            .parse_group_recur(struct.update(group: 'root'))
    end

    def parse_group_recur(struct)
      special, rest = struct.partition { |k, _| SPECIAL_KEYS.include? k }.map(&:to_h)
      group, contains = special.values_at(*SPECIAL_KEYS)

      ret = []
      frame do |f|
        # Update attributes
        f.attributes.update rest unless rest.nil?
        f.processors << Processor.class_for(group).new(**f.attributes)
        ret.concat(contains.map { |e| determine_and_parse_entry(e) })
      end
      ret.flatten # flatten the cascaded arrays of entries
    end

    private

    def initialize
      @frames = [Frame.new]
    end

    def frame
      @frame = @frames.last.dup
      @frames.push @frame
      res = yield @frame
      @frames.pop
      res
    end

    class Frame
      attr_reader :attributes, :processors

      def initialize(processors = [], attributes = {})
        @processors = processors
        @attributes = attributes
      end
    end

    def parse_item(struct, namespace)
      id, processors = struct.values_at :id, :processors
      frame do |f|
        # FIXME: dup on this level wont preserve the state of @nxt
        copy = f.processors.dup
        copy.concat processors.map { Processor.from_struct(_1, f.attributes) }
        Entry.new(Identifier.new(namespace, id), copy)
      end
    end

    def determine_and_parse_entry(entry)
      namespace = @frame.attributes[:namespace]

      case entry
      when String
        # Simple string
        Entry.new(Identifier.new(namespace, entry), @frame.processors.dup)
      when Hash
        return parse_group_recur(entry) if entry.key? :group
        return parse_item(entry, namespace) if entry.key? :id
      else
        warn "Entry not recognized: #{entry}"
      end
    end
  end
end
