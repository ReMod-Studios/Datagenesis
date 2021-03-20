# frozen_string_literal: true

module Datagenesis
  # Represents a pipeline processor that
  # processes and outputs data.
  class Processor
    attr_accessor :nxt

    def initialize(**kwargs)
      # Left blank for runtime patching needs
    end

    def process(entry)
      @nxt&.process entry
    end

    private

    def method_missing(sym, *args)
      if sym.start_with? 'process'
        begin
          original = self.class.method(sym)
          # make it accessible even if a naming clash occurs
          define_method(:"#{sym}!", original) unless original.nil?
        rescue NameError => _e
          # Ignored
        end

        forward = lambda do |*a, **kwargs, &block|
          # forward the message
          @nxt&.send(sym, *a, **kwargs, &block)
        end

        self.class.define_method(sym, &forward)
        forward.call(*args)
      else
        super
      end
    end

    def forward(*args, **kwargs, &block)
      caller = caller_locations(1, 1)[0].label.to_sym
      @nxt&.send(caller, *args, **kwargs, &block)
    end

    def respond_to_missing?(*args)
      sym.start_with?('process') || super
    end

    @id_to_class = {}

    class << self
      def register(id)
        Processor.id_to_class[id.to_sym] = self
      end

      def class_for(id)
        Processor.id_to_class[id.to_sym] || raise(ArgumentError, "#{id} not found in processor registry")
      end

      def from_struct(struct, attributes = {})
        if struct.is_a? String
          class_for(struct).new(**attributes)
        else
          id = struct[:id]
          rest = struct.reject { |k, _| k == :id }.update attributes
          class_for(id).new(**rest)
        end
      end

      def processor_attr(*names)
        init = instance_method(:initialize)

        # TODO: somehow enforce dynamic keywords onto the thing
        define_method(:initialize) do |**kwargs|
          init.bind(self).call(**kwargs)
          names.each do |n|
            instance_variable_set(:"@#{n}", kwargs.fetch(n))
          end
        end
      end

      protected

      attr_reader :id_to_class
    end
  end
end
