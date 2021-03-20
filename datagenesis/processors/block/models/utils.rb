# frozen_string_literal: true

module Datagenesis
  module Processors
    module Block
      module ModelUtils
        def ignore_zero(val)
          val != 0 ? val : nil
        end

        def conf_variant_blockstate
          variants = yield || {}
          {
            'variants': variants
          }
        end

        def conf_multipart_blockstate
          multipart = yield || {}
          {
            'multipart': multipart
          }
        end
      end
    end
  end
end
