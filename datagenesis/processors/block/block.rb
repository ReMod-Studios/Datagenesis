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

          block_path = id.prefixed 'block'

          process_block_model id, {
            'parent': 'minecraft:block/cube_all',
            'textures': {
              'all': block_path
            }
          }

          process_blockstate id, {
            'variants': {
              '': { 'model': block_path }
            }
          }

          process_loot_table id, {
            'type': 'minecraft:block',
            'pools': [
              {
                'rolls': 1.0,
                'bonus_rolls': 0.0,
                'entries': [
                  {
                    'type': 'minecraft:item',
                    'name': id.to_s
                  }
                ],
                'conditions': [{ 'condition': 'minecraft:survives_explosion' }]
              }
            ]
          }
        end
      end
    end
  end
end
