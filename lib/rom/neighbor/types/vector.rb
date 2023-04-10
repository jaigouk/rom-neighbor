# frozen_string_literal: true

require 'pgvector'

module ROM
  module Neighbor
    module Types
      class Vector < Pgvector::PG::TextDecoder::Vector
        def call(input_vector)
          decode("{#{input_vector.join(',')}}")
        end
      end
    end
  end
end
