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
          data[:variants] = {
            'axis=x': { model: hblock_id, x: 90, y: 90 },
            'axis=y': { model: block_id },
            'axis=z': { model: hblock_id, x: 90 }
          }
          forward(id, data)
        end

        def process_block_model(id, data)
          textures_hsh = {
            'end': id.wrap_path(prefix: 'block/', suffix: '_top'),
            'side': id.wrap_path(prefix: 'block/')
          }

          @nxt.process_block_model(
            id,
            data.merge({ parent: 'minecraft:block/cube_column', textures: textures_hsh })
          )
          @nxt.process_block_model(
            id.wrap_path(suffix: '_horizontal'),
            data.merge({ parent: 'minecraft:block/cube_column_horizontal', textures: textures_hsh })
          )
        end
      end
    end
  end
end
