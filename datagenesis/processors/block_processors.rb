# frozen_string_literal: true

%w[
  block
  block_settings
  render_layer
  shorthand/stone_properties
  shorthand/wooden_properties
  models/log
  models/door
].each { |e| require_relative "block/#{e}" }
