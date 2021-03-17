# frozen_string_literal: true

module Datagenesis
  module Processors
    module Block
      class RenderLayer < Processor
        register :render_layer

        processor_attr :layer
      end
    end
  end
end

