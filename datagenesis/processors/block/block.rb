# frozen_string_literal: true

module Datagenesis
  module Processors
    module Block
      class Block < Processor
        register :block
        processor_attr :java_class
      end
    end
  end
end
