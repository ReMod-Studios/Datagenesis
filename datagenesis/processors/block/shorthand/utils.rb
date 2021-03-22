# frozen_string_literal: true

require_relative '../../../util/ext/hash'

module Datagenesis
  module Processors
    module Block
      module ToolSpecificDropsUtils
        TOOL_PREFIXES = %w[wooden stone golden iron diamond netherite].freeze

        def tool_condition(tool_type)
          "query.equipped_item_any_tag('slot.weapon.mainhand', 'minecraft:is_#{tool_type}') || "\
          "#{
            TOOL_PREFIXES
              .map { "query.get_equipped_item_name == '#{_1}_#{tool_type}'" }
              .join(' || ')
          }"
        end

        def update_break_event_component(components, tool_type, id)
          components.update(
            'minecraft:loot': 'loot_tables/empty.json',
            'minecraft:on_player_destroyed': {
              target: 'self',
              event: 'on_break',
              condition: tool_condition(tool_type)
            }
          )
        end

        def add_spawn_loot_event(events, id)
          events.update(
            on_break: {
              sequence: [{
                spawn_loot: { "table": "loot_tables/blocks/#{id.path}.json" }
              }]
            }
          )
        end
      end
    end
  end
end