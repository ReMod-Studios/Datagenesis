# frozen_string_literal: true

module Datagenesis
  module Processors
    module Block
      class Block < Processor
        register :block
        processor_attr :java_class, :package

        def process(entry)
          id = entry.id
          block_path = id.wrap_path prefix: 'block/'

          def_model id, block_path
          def_blockstate id, block_path
          def_loot_table id
          def_behavior id
          super
        end

        def def_model(id, block_path)
          process_java_block_model id, {
            parent: 'minecraft:block/cube_all',
            textures: { all: block_path }
          }

          process_bedrock_block_resource id, {
            textures: id.path
          }
        end

        def def_blockstate(id, block_path)
          process_java_block_state id, {
            variants: { '': { model: block_path } }
          }
        end

        def def_loot_table(id)
          process_java_loot_table id, {
            type: 'minecraft:block',
            pools: [{
              rolls: 1.0,
              bonus_rolls: 0.0,
              entries: [{ type: 'minecraft:item', name: id }],
              conditions: [{ condition: 'minecraft:survives_explosion' }]
            }]
          }
        end

        def def_behavior(id)
          process_bedrock_block_behavior id, {
            format_version: '1.16.100',
            'minecraft:block': {
              description: {
                identifier: id,
                is_experimental: false
              },
              components: def_behavior_components(id)
            }
          }
        end

        def def_behavior_components(id)
          {
            'minecraft:loot': "loot_tables/#{id.path}.json",
            'minecraft:destroy_time': 1,
            'minecraft:explosion_resistance': 1,
            'minecraft:friction': 0.6,
            'minecraft:flammable': {
              flame_odds: 0,
              burn_odds: 0
            },
            'minecraft:map_color': '#FFFFFF',
            'minecraft:block_light_absorption': 1,
            'minecraft:block_light_emission': 0,
            'minecraft:unit_cube': {},
            'minecraft:breathability': 'solid',
            'minecraft:breakonpush': false,
            'minecraft:material_instances': {
              '*': {
                texture: id.path,
                render_method: 'opaque'
              }
            }
          }
        end
      end
    end
  end
end
