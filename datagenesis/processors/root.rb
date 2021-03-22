# frozen_string_literal: true

require_relative 'end/resources/bedrock'

module Datagenesis
  module Processors
    class Root < Processor
      register :root

      def process(entry)
        process_json("#{Datagenesis::Processors::End::BEHAVIOR_PACK}/loot_tables/empty.json", {})
        super
      end
    end
  end
end
