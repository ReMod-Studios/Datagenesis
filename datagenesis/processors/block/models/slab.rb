# frozen_string_literal: true

require_relative '../../../util/variant'
require_relative '../../../util/ext/hash'
require_relative 'utils'

module Datagenesis
  module Processors
    module Block
      class SlabModel < Processor
        include Datagenesis::Processors::Block::ModelUtils

        register :slab_model
        processor_attr :namespace, :base_block

        PROPERTIES = %i[horizontal_facing double_half door_hinge open].freeze
        VARIANTS = Datagenesis::VariantFactory.build PROPERTIES

        def process_blockstate(id, data)
          model_id = id.wrap_path(prefix: 'block/')
          top_model_id = id.wrap_path(prefix: 'block/', suffix: '_top')
          base_model_id = Identifier.new(@namespace, "block/#{@base_block}")

          conf_variant_blockstate(data) do |variants|
            variants.replace(
              {
                'type=bottom': { model: model_id },
                'type=top': { model: top_model_id },
                'type=double': { model: base_model_id }
              }
            )
          end

          forward(id, data)
        end

        def process_block_model(id, data)
          base_tex_id = Identifier.new(@namespace, "block/#{@base_block}")

          data[:textures] = {
            top: base_tex_id,
            bottom: base_tex_id,
            side: base_tex_id
          }

          forwarder = CommonModelForwarder.new(@nxt, id, data, 'minecraft:block/slab')

          forwarder.forward ''
          forwarder.forward '_top'
        end


        def process_loot_table(id, loot_table, category = 'blocks')
          loot_table[:pools].each do |pool|
            pool[:entries].each do |entry|
              entry.modify_or_initialize(:functions, []) do |functions|
                functions << get_set_count_func(id)
                functions << { function: 'minecraft:explosion_decay' }
              end
            end
          end
          forward(id, loot_table, category)
        end

        private

        def get_set_count_func(id)
          {
            function: 'minecraft:set_count',
            conditions: [{
              condition: 'minecraft:block_state_property',
              block: id,
              properties: { "type": 'double' }
            }],
            count: 2.0,
            add: false
          }
        end
      end
    end
  end
end
