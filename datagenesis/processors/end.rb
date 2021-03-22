# frozen_string_literal: true

require_relative 'end/resources'

module Datagenesis
  module Processors
    class End < Processor
      register :end

      def process_end
        bedrock_conclude
      end

      def process_file(path, cont)
        dir = File.dirname(path)
        FileUtils.mkdir_p(dir) unless Dir.exist? dir
        File.write(path, cont)
      end

      def process_json(path, data)
        process_file(path, JSON.pretty_generate(data))
      end
    end
  end
end
