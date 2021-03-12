# frozen_string_literal: true

require 'json'
require 'fileutils'
require_relative 'entry'
require_relative 'processor'
require_relative 'identifier'

module Datagenesis
  # Parser for the datagenesis.yml structure
  class Parser
    def parse_group(struct)
      # Default values: no meta, root dummy processor
      parse_group_recur(struct.update(group: 'root'), {}, [])
    end

    private

    def parse_item(struct, namespace, prev_processors)
      id, processors = struct.values_at :id, :processors
      parsed_processors = prev_processors
                          .dup
                          .concat(processors.map { |p| Processor.from_struct(p) })
      Entry.new(Identifier.new(namespace, id), parsed_processors)
    end

    def determine_and_parse_entry(entry, meta, prev_processors)
      namespace = meta[:namespace]

      case entry
      when String
        # Simple string
        Entry.from_ns_and_id(namespace, entry, prev_processors)
      when Hash
        return parse_group_recur(entry, meta, prev_processors) if entry.key? :group
        return parse_item(entry, namespace, prev_processors) if entry.key? :id
      else
        warn "Entry not recognized: #{entry}"
      end
    end

    def parse_group_recur(struct, meta, prev_processors)
      new_meta, group, contains = struct.values_at :meta, :group, :contains

      # Update metadata
      meta.update new_meta unless new_meta.nil?

      prev_processors.push Processor.from_struct(group)

      ret = contains.map { |e| determine_and_parse_entry(e, meta, prev_processors) }

      prev_processors.pop
      ret.flatten # flatten the cascaded arrays of entries
    end
  end
end
