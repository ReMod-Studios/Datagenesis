# frozen_string_literal: true

module Datagenesis
  module Processors
    class End < Processor
      register :end

      def process_block_model(id, model)
        process_model(id, 'block', model)
      end

      def process_item_model(id, model)
        process_model(id, 'item', model)
      end

      def process_model(id, category, model)
        process_json(
          "java_resources/assets/#{id.namespace}/models/#{category}/#{id.path}.json",
          model
        )
      end

      def process_blockstate(id, blockstate)
        process_json(
          "java_resources/assets/#{id.namespace}/blockstates/#{id.path}.json",
          blockstate
        )
      end

      def process_loot_table(id, loot_table, category = 'blocks')
        process_json(
          "java_resources/data/#{id.namespace}/loot_tables/#{category}/#{id.path}.json",
          loot_table
        )
      end

      def process_json(path, data)
        dir = File.dirname(path)
        FileUtils.mkdir_p(dir) unless Dir.exist? dir
        File.write(path, JSON.pretty_generate(data))
      end
    end
  end
end
