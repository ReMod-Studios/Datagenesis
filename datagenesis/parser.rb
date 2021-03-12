# frozen_string_literal: true

require 'json'
require 'fileutils'
require_relative 'entry'
require_relative 'processor'
require_relative 'identifier'

module Datagenesis
  # Parser for the datagenesis.yml structure
  class Parser
    def self.parse_struct(struct)
      # Default values: no meta, root dummy processor
      Parser.new.parse_group_recur(struct.update(group: 'root'))
    end

    def parse_group_recur(struct)
      meta, group, contains = struct.values_at :meta, :group, :contains

      # Update meta
      @meta.update meta unless meta.nil?

      @processors.push Processor.from_struct(group)

      ret = contains.map { |e| determine_and_parse_entry(e) }

      @processors.pop
      ret.flatten # flatten the cascaded arrays of entries
    end

    private

    def initialize(meta = {}, processors = [])
      @meta = meta
      @processors = processors
    end

    def parse_item(struct, namespace)
      id, processors = struct.values_at :id, :processors
      parsed_processors = @processors
                          .dup
                          .concat(processors.map { |p| Processor.from_struct(p) })
      Entry.new(Identifier.new(namespace, id), parsed_processors)
    end

    def determine_and_parse_entry(entry)
      namespace = @meta[:namespace]

      case entry
      when String
        # Simple string
        Entry.new(Identifier.new(namespace, entry), @processors.dup)
      when Hash
        return parse_group_recur(entry) if entry.key? :group
        return parse_item(entry, namespace) if entry.key? :id
      else
        warn "Entry not recognized: #{entry}"
      end
    end
  end
end
