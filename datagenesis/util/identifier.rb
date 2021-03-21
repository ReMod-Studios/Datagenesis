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

    def wrap_path(prefix: '', suffix: '')
      Identifier.new(@namespace, prefix + @path + suffix)
    end

    def inspect
      %(Identifier["#{@namespace}:#{@path}"])
    end
  end
end

class String
  def to_id
    Identifier.new(*split(':'))
  end
end
