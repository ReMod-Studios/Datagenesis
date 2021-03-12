# frozen_string_literal: true

module Datagenesis
  # Just like a Minecraft identifier.
  class Identifier
    attr_reader :namespace, :path

    def initialize(namespace, path)
      @namespace = namespace || raise('Namespace must not be nil')
      @path = path || raise('Path must not be nil')
    end

    def to_s
      "#{@namespace}:#{@path}"
    end

    def inspect
      %("#{@namespace}:#{@path}")
    end
  end
end
