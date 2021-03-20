# frozen_string_literal: true

require 'yaml'

require_relative 'datagenesis'

module Datagenesis

  test = YAML.safe_load_file('datagenesis.yml', symbolize_names: true)

  Dir.chdir('out')
  entries = Parser.parse_struct(test)
  pp entries

  entries.each(&:process)

end
