# frozen_string_literal: true

require 'rom/types'
require 'rom/sql/types'

module Types
  module PG
    class Vector < ROM::Types::Value
      def initialize(dimensions:, normalize:, model:, attribute_name:)
        super()
        @dimensions = dimensions
        @normalize = normalize
        @model = model
        @attribute_name = attribute_name
      end

      def self.cast(value, dimensions:, normalize:, column_info:)
        dimensions ||= column_info[:dimensions]
        validate_dimensions(value, dimensions) if dimensions
        validate_values(value)
        normalize_values(value) if normalize
      end

      def self.validate_dimensions(value, dimensions)
        raise Error, "Expected #{dimensions} dimensions, not #{value.size}" if value.size != dimensions
      end

      def self.validate_values(value)
        raise Error, 'Values must be finite' unless value.all?(&:finite?)
      end

      def self.normalize_values(value)
        norm = Math.sqrt(value.sum { |v| v * v })
        return if norm.zero?

        value.map! { |v| v / norm }
      end

      def self.column_info(model, attribute_name)
        attribute_name = attribute_name.to_s
        column = model.columns.detect { |c| c.name == attribute_name }
        {
          type: column.try(:type),
          dimensions: column.try(:limit)
        }
      end

      def column_info
        @column_info ||= self.class.column_info(@model, @attribute_name)
      end

      def call(value)
        return if value.nil?

        self.class.cast(value, dimensions: @dimensions, normalize: @normalize,
                               column_info: column_info)
      end

      def serialize(value)
        return if value.nil?

        if column_info[:type] == :vector
          "[#{cast(value).join(', ')}]"
        else
          "(#{cast(value).join(', ')})"
        end
      end

      def deserialize(value)
        value[1..].split(',').map(&:to_f) unless value.nil?
      end
    end

    Cube = ROM::SQL::Types.Definition(ROM::SQL::Types::String)
    Vector = Vector.constructor
  end
end
