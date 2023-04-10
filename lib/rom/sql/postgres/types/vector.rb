# frozen_string_literal: true

require 'rom/sql/type_extensions'

module ROM
  module SQL
    module Postgres
      module Types
        class TextEncoderVector
          def encode(array)
            "[#{array.join(',')}]"
          end
        end

        module BinaryEncoder
          class Vector < ::PG::SimpleEncoder
            def encode(value, _tuple = nil, _field = nil)
              dim = value.size
              [dim, 0].pack('nn') + value.pack("g#{dim}")
            end
          end
        end

        class Vector
          def initialize
            @type = ROM::SQL::Types::String
            @binary = false # Set to true if you want to use binary decoding
          end

          # def call(value)
          #   @type.call(value)
          # end
          def call(input_vector)
            input_vector.map { |value| value.nil? ? 0.0 : value }
          end

          def load(value)
            decode(value)
          end

          def dump(value)
            if @binary
              ::ROM::SQL::Postgres::Types::BinaryEncoder::Vector.new.encode(value)
            else
              ::ROM::SQL::Postgres::Types::TextEncoder::Vector.new.encode(value)
            end
          end

          # def decode(string, tuple = nil, field = nil)
          #   if @binary
          #     dim, unused = string[0, 4].unpack("nn")
          #     raise "expected unused to be 0" if unused != 0
          #     string[4..-1].unpack("g#{dim}")
          #   else
          #     string[1..-2].split(",").map(&:to_f)
          #   end
          # end
          def decode(input)
            return input if input.is_a?(::Array)

            dim, _unused = input[0, 4].unpack('nn')
            data = input[4..]
            data.unpack("G#{dim}")
          end
        end
      end
    end
  end
end
