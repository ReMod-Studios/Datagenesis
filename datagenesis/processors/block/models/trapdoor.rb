# frozen_string_literal: true

require_relative '../../../util/variant'
require_relative 'utils'

module Datagenesis
  module Processors
    module Block
      class TrapdoorModel < Processor
        include Datagenesis::Processors::Block::ModelUtils

        register :trapdoor_model
        PROPERTIES = %i[horizontal_facing block_half open].freeze
        VARIANTS = Datagenesis::VariantFactory.build(*PROPERTIES)

        def process_blockstate(id, data)
          conf_variant_blockstate(data, variants: VARIANTS) { |var| map_each_variant(var, id) }

          forward(id, data)
        end

        def process_block_model(id, data)
          data[:textures] = { texture: id.wrap_path(prefix: 'block/') }

          forward_model('_bottom', id, data)
          forward_model('_top', id, data)
          forward_model('_open', id, data)
        end

        private

        def forward_model(path_suffix, id, data)
          @nxt.process_block_model(
            id.wrap_path(suffix: path_suffix),
            data.merge(
              {
                parent: "minecraft:block/template_orientable_trapdoor#{path_suffix}"
              }
            )
          )
        end

        # region Helpers
        def map_each_variant(var, id)
          facing, half, open = var[*PROPERTIES]

          open_and_top = open && half.eql?(:top)

          var_obj = {
            model: "#{id.namespace}:block/#{id.path}_#{open ? 'open' : half.to_s}",
            x: (180 if open_and_top),
            y: calc_y_rot(facing, open_and_top)
          }.compact

          [var.to_s, var_obj]
        end

        def calc_y_rot(direction, open_and_top)
          y = direction.horizontal_ord
          y += 2 unless open_and_top
          ignore_zero y % 4 * 90
        end
        # endregion
      end
    end
  end
end

