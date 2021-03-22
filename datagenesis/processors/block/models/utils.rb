# frozen_string_literal: true

require_relative '../../../util/ext/hash'

module Datagenesis
  module Processors
    module Block
      module ModelUtils
        def ignore_zero(val)
          val != 0 ? val : nil
        end

        def conf_variant_blockstate(data = {}, variants: nil, &block)
          b = if variants.nil?
                block
              else
                lambda do |vars|
                  vars.replace variants.map { |var| block.call(var) }.to_h
                end
              end

          data.delete :multipart # mutually exclusive
          data.modify_or_initialize :variants, {}, &b
        end

        def conf_multipart_blockstate(data = {}, &block)
          data.delete :variants # mutually exclusive
          data.modify_or_initialize :multipart, [], &block
        end

        CommonModelForwarder = Struct.new :nxt, :id, :data, :parent_base do
          def forward(path_suffix = nil, parent_suffix = path_suffix)
            nxt.process_java_block_model(
              path_suffix.nil? ? id : id.wrap_path(suffix: path_suffix),
              data.merge(
                {
                  parent: (parent_suffix.nil? ? parent_base : parent_base + parent_suffix)
                }
              )
            )
          end
        end
      end
    end
  end
end
