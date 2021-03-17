# frozen_string_literal: true

require 'yaml'

require_relative 'datagenesis'

test = YAML.safe_load_file('datagenesis.yml', symbolize_names: true)

entries = Datagenesis::Parser.parse_struct(test)
pp entries
entries.each(&:process)
