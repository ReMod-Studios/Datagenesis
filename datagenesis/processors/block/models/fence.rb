# frozen_string_literal: true

require_relative '../../../util/variant'
require_relative 'utils'

module Datagenesis
  module Processors
    module Block
      class FenceModel < Processor
        register :fence_model
        include Datagenesis::Processors::Block::ModelUtils

        def process_blockstate(id, data)
          post_id = id.wrap_path(prefix: 'block/', suffix: '_post')
          side_id = id.wrap_path(prefix: 'block/', suffix: '_side')

          conf_multipart_blockstate(data) do |m|
            m << { apply: { model: post_id.to_s } }
            m << { when: { north: 'true' }, apply: { model: side_id.to_s, uvlock: true         } }
            m << { when: { east:  'true' }, apply: { model: side_id.to_s, uvlock: true, y: 90  } }
            m << { when: { south: 'true' }, apply: { model: side_id.to_s, uvlock: true, y: 180 } }
            m << { when: { west:  'true' }, apply: { model: side_id.to_s, uvlock: true, y: 270 } }
          end

          forward(id, data)
        end

        def process_block_model(id, data)
          textures_hsh = {
            texture: id.wrap_path(prefix: 'block/')
          }
          data.update textures: textures_hsh

          forwarder = CommonModelForwarder.new(@nxt, id, data, 'minecraft:block/fence')

          forwarder.forward '_post'
          forwarder.forward '_side'
          forwarder.forward '_inventory'
        end
      end
    end
  end
end
