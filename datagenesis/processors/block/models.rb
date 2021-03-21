# frozen_string_literal: true

%w[
  log door fence
].each { |e| require_relative "models/#{e}" }
