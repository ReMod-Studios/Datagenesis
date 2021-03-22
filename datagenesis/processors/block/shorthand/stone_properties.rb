# frozen_string_literal: true

require_relative '../../../util/ext/hash'
require_relative 'utils'

module Datagenesis
  module Processors
    module Block
      class StoneProperties < Processor
        register :stone_properties

        include Datagenesis::Processors::Block::ToolSpecificDropsUtils

        def process_bedrock_block_behavior(id, behavior)
          block_section = behavior[:'minecraft:block']
          modify_components block_section, id
          modify_events block_section, id
          forward id, behavior
        end

        def modify_components(block_section, id)
          block_section.modify_or_initialize(:components, {}) do |components|
            components.update(
              'minecraft:destroy_time': 4,
              'minecraft:explosion_resistance': 2.5,
              'tag:stone': {}
            )
            update_break_event_component components, 'pickaxe', id
          end
        end

        def modify_events(block_section, id)
          block_section.modify_or_initialize(:events, {}) do |events|
            events.update(
              'on_break': {
                'sequence': [{
                  "spawn_loot": { "table": "loot_tables/blocks/#{id.path}.json" }
                }]
              }
            )
          end
        end
      end
    end
  end
end
