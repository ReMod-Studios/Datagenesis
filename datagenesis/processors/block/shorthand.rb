# frozen_string_literal: true

%w[
  stone_properties
  wooden_properties
].each { |e| require_relative "shorthand/#{e}" }
