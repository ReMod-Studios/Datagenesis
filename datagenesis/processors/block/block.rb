# frozen_string_literal: true

module Datagenesis
  module Processors
    module Block
      class Block < Processor
        register :block
        processor_attr :java_class, :package

        def process(entry)
          super
          id = entry.id
          block_path = id.wrap_path prefix: 'block/'

          def_model id, block_path
          def_blockstate id, block_path
          def_loot_table id
        end

        def def_model(id, block_path)
          process_block_model id, {
            parent: 'minecraft:block/cube_all',
            textures: { all: block_path }
          }
        end

        def def_blockstate(id, block_path)
          process_blockstate id, {
            variants: { '': { model: block_path } }
          }
        end

        def def_loot_table(id)
          process_loot_table id, {
            type: 'minecraft:block',
            pools: [{
              rolls: 1.0,
              bonus_rolls: 0.0,
              entries: [{ type: 'minecraft:item', name: id }],
              conditions: [{ condition: 'minecraft:survives_explosion' }]
            }]
          }
        end
      end
    end
  end
end
