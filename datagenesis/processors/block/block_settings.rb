# frozen_string_literal: true

module Datagenesis
  module Processors
    module Block
      class BlockSettings < Processor
        register :block_settings

        # TODO: add more settings
        def initialize(luminance:, **kwargs)
          super(**kwargs)
          @luminance = luminance
        end
      end
    end
  end
end
