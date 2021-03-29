# frozen_string_literal: true

require_relative '../../../util/ext/hash'

module Datagenesis
  module Processors
    class End < Processor
      BEHAVIOR_PACK = 'bedrock_behavior_pack'
      RESOURCE_PACK = 'bedrock_resource_pack'

      def bedrock_init
        @blocks_json = { format_version: [1, 1, 0] }
        @items_json = {}
      end

      def process_bedrock_block_resource(id, resource)
        @blocks_json.modify_or_initialize(id.to_s, {}) do |rsrc|
          rsrc.replace resource
        end
      end

      def process_bedrock_item_resource(id, model)
        # TODO
      end

      def process_bedrock_block_behavior(id, behavior)
        process_json("#{BEHAVIOR_PACK}/blocks/#{id.path}.json", behavior)
      end

      def process_bedrock_loot_table(id, loot_table, category = 'blocks')
        process_json("#{BEHAVIOR_PACK}/loot_tables/#{category}/#{id.path}.json", loot_table)
      end

      def bedrock_conclude
        process_json("#{RESOURCE_PACK}/blocks.json", @blocks_json)
        process_json("#{RESOURCE_PACK}/items.json", @items_json)
      end
    end
  end
end
