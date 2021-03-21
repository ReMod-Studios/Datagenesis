# frozen_string_literal: true

require_relative '../../../util/variant'
require_relative 'utils'

module Datagenesis
  module Processors
    module Block
      class LogModel < Processor
        register :log_model
        include Datagenesis::Processors::Block::ModelUtils

        def process_blockstate(id, data)
          block_id = id.wrap_path(prefix: 'block/')
          hblock_id = id.wrap_path(prefix: 'block/', suffix: '_horizontal')

          conf_variant_blockstate(data) do |variants|
            variants.replace(
              {
                'axis=x': { model: hblock_id, x: 90, y: 90 },
                'axis=y': { model: block_id },
                'axis=z': { model: hblock_id, x: 90 }
              }
            )
          end

          forward(id, data)
        end

        def process_block_model(id, data)
          data[:textures] = {
            end: id.wrap_path(prefix: 'block/', suffix: '_top'),
            side: id.wrap_path(prefix: 'block/')
          }

          forwarder = CommonModelForwarder.new(@nxt, id, data, 'minecraft:block/log')

          forwarder.forward ''
          forwarder.forward '_horizontal'
        end
      end
    end
  end
end
