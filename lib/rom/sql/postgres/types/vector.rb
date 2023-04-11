# frozen_string_literal: true

require 'rom/sql/types'
require 'rom/sql/type_extensions'
require 'pgvector'

module ROM
  module SQL
    module Postgres
      # check https://github.com/rom-rb/rom-sql/blob/main/lib/rom/sql/extensions/postgres/types.rb
      module Types
        Vector = Type("vector") do
          read = SQL::Types.Constructor(Hash, &:to_hash)

          SQL::Types.Constructor(Hash, &Sequel.method(:hstore))
            .meta(read: read)
        end

        # class Vector
        #   def initialize(configuration)
        #     @type = ROM::SQL::Types::String
        #     @binary = false
        #   end

        #   def call(input_vector)
        #     input_vector.map { |value| value.nil? ? 0.0 : value }
        #   end

        #   def load(value)
        #     value
        #   end

        #   def dump(value)
        #     value
        #   end

        # end
      end
    end
  end
end

# require "pg"

# module Pgvector
#   module PG
#     def self.register_vector(registry)
#       registry.register_type(0, "vector", nil, TextDecoder::Vector)
#       registry.register_type(1, "vector", nil, BinaryDecoder::Vector)
#     end

#     module BinaryDecoder
#       class Vector < ::PG::SimpleDecoder
#         def decode(string, tuple = nil, field = nil)
#           dim, unused = string[0, 4].unpack("nn")
#           raise "expected unused to be 0" if unused != 0
#           string[4..-1].unpack("g#{dim}")
#         end
#       end
#     end

#     module TextDecoder
#       class Vector < ::PG::SimpleDecoder
#         def decode(string, tuple = nil, field = nil)
#           string[1..-2].split(",").map(&:to_f)
#         end
#       end
#     end
#   end
# end
