# frozen_string_literal: true

module Datagenesis
  module Processors
    module Block
      class WoodenProperties < Processor
        register :wooden_properties

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
              'minecraft:destroy_time': 3,
              'minecraft:explosion_resistance': 1.5,
              'tag:stone': {}
            )
            update_break_event_component components, 'axe', id
          end
        end

        def modify_events(block_section, id)
          block_section.modify_or_initialize(:events, {}) do |events|
            add_spawn_loot_event events, id
          end
        end
      end
    end
  end
end
