# frozen_string_literal: true

require 'yaml'

test = YAML.safe_load_file('datagenesis.yml', symbolize_names: true)
pp test


