# frozen_string_literal: true

module Datagenesis
  # Just like a Minecraft identifier.
  class Identifier
    attr_reader :namespace, :path

    def initialize(namespace, path)
      @namespace = namespace.freeze || raise('Namespace must not be nil')
      @path = path.freeze || raise('Path must not be nil')
    end

    def to_s
      "#{@namespace}:#{@path}"
    end

    def prefixed(*prefixes, join_char: '/')
      Identifier.new(namespace, "#{prefixes.join(join_char)}#{join_char}#{path}")
    end

    def suffixed(*suffixes, join_char: '_')
      Identifier.new(namespace, "#{path}#{join_char}#{suffixes.join(join_char)}")
    end

    def wrap_path(prefix = '', suffix = '')
      Identifier.new(namespace, prefix + path + suffix)
    end

    def inspect
      %(Identifier["#{@namespace}:#{@path}"])
    end
  end
end
