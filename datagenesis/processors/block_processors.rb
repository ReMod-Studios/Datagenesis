# frozen_string_literal: true

%w[
  block
  block_settings
  render_layer
  shorthand
  models
].each { |e| require_relative "block/#{e}" }
