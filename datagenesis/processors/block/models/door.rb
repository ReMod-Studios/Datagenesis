# frozen_string_literal: true

require_relative '../../../util/variant'
require_relative '../../../util/ext/hash'
require_relative 'utils'

module Datagenesis
  module Processors
    module Block
      class DoorModel < Processor
        include Datagenesis::Processors::Block::ModelUtils

        register :door_model
        PROPERTIES = %i[horizontal_facing double_half door_hinge open].freeze
        VARIANTS = Datagenesis::VariantFactory.build PROPERTIES

        def process_blockstate(id, data)
          conf_variant_blockstate(data, variants: VARIANTS) { |var| map_each_variant(var, id) }

          forward(id, data)
        end

        def process_block_model(id, data)
          data[:textures] = {
            top: id.wrap_path(prefix: 'block/', suffix: '_top'),
            bottom: id.wrap_path(prefix: 'block/', suffix: '_bottom')
          }

          forwarder = CommonModelForwarder.new(@nxt, id, data, 'minecraft:block/door')

          forwarder.forward '_bottom'
          forwarder.forward '_bottom_hinge', '_bottom_rh'
          forwarder.forward '_top'
          forwarder.forward '_top_hinge', '_top_rh'
        end

        def process_loot_table(id, loot_table, category = 'blocks')
          loot_table[:pools].each do |pool|
            pool[:entries].each do |entry|
              entry.modify_or_initialize(:conditions, []) do |conditions|
                conditions << block_state_property_cond(id)
              end
            end
          end

          forward(id, loot_table, category)
        end

        private

        def block_state_property_cond(id)
          {
            condition: 'minecraft:block_state_property',
            block: id,
            properties: { 'half': 'lower' }
          }
        end

        # region Helpers
        def map_each_variant(var, id)
          facing, hinge, half, open = var[*PROPERTIES]
          is_hinge_left = hinge.eql?(:left)

          var_obj = {
            model: make_model_string(id, is_hinge_left, open, half),
            y: calc_y_rot(facing, is_hinge_left, open)
          }.compact

          [var.to_s, var_obj]
        end

        def make_model_string(id, is_hinge_left, open, half)
          # Evil bitwise operation of a truth pattern I observed
          # that is somewhat similar to an XNOR.
          # Seriously, WTF, Mojang?
          #         left  right
          #    open   T     F
          #  closed   F     T
          has_hinge = is_hinge_left ^ (!open)

          "#{id.namespace}:block/#{id.path}"\
              "_#{half == :upper ? 'top' : 'bottom'}"\
              "#{'_hinge' if has_hinge}"
        end

        def calc_y_rot(direction, is_hinge_left, open)
          hid = direction.horizontal_ord + 1
          hid += is_hinge_left ? 1 : -1 if open
          ignore_zero hid % 4 * 90
        end
        # endregion
      end
    end
  end
end
