# frozen_string_literal: true

%w[
  log door fence trapdoor
].each { |e| require_relative "models/#{e}" }
