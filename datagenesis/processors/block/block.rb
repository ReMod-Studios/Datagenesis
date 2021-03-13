# frozen_string_literal: true

module Datagenesis
  module Processors
    module Block
      class Block < Processor
        register :block

        def initialize(java_class:, **kwargs)
          super(**kwargs)
          @java_class = java_class
        end
      end
    end
  end
end
