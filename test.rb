# frozen_string_literal: true

require 'yaml'

require_relative 'datagenesis'

test = YAML.safe_load_file('datagenesis.yml', symbolize_names: true)

pp Datagenesis::Parser.new.parse_group(test)
