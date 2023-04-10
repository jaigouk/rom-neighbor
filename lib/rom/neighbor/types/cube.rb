# frozen_string_literal: true

require 'rom-sql'

module ROM
  module Neighbor
    module Types
      module PG
        Cube = ROM::SQL::Types::String.constructor do |value|
          value.is_a?(String) ? Sequel.pg_cube(value) : value
        end
      end
    end
  end
end
