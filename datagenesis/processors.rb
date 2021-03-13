# frozen_string_literal: true

%w[
  block_processors end root
].each { |e| require_relative "processors/#{e}" }
