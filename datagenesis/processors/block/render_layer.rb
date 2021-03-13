# frozen_string_literal: true

module Datagenesis
  module Processors
    module Block
      class RenderLayer < Processor
        register :render_layer

        def initialize(layer:, **kwargs)
          super(**kwargs)
          @layer = layer
        end
      end
    end
  end
end

