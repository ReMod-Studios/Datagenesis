# frozen_string_literal: true

require_relative 'resources/bedrock'
require_relative 'resources/java'

module Datagenesis
  module Processors
    class End
      def process_loot_table(id, loot_table, category = 'blocks')
        process_java_loot_table id, loot_table, category: category
        process_bedrock_loot_table id, loot_table, category: category
      end
    end
  end
end
