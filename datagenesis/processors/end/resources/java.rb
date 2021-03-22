# frozen_string_literal: true

module Datagenesis
  module Processors
    class End < Processor
      def process_java_block_model(id, model)
        process_java_model(id, 'block', model)
      end

      def process_java_item_model(id, model)
        process_java_model(id, 'item', model)
      end

      def process_java_model(id, category, model)
        process_json(
          "java_resources/assets/#{id.namespace}/models/#{category}/#{id.path}.json",
          model
        )
      end

      def process_java_block_state(id, blockstate)
        process_json(
          "java_resources/assets/#{id.namespace}/blockstates/#{id.path}.json",
          blockstate
        )
      end

      def process_java_loot_table(id, loot_table, category = 'blocks')
        process_json(
          "java_resources/data/#{id.namespace}/loot_tables/#{category}/#{id.path}.json",
          loot_table
        )
      end
    end
  end
end
