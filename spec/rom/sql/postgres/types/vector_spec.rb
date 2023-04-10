# frozen_string_literal: true

require 'spec_helper'
require 'pgvector'
require 'rom/sql/postgres/types/vector'

RSpec.describe ROM::SQL::Postgres::Types::Vector do
  let(:conn) { RSpec.configuration.pg_vector_connection }
  let(:vector_type) { described_class.new }

  describe 'Vector column' do
    it 'casts a vector preserving the input values' do
      input_vector = [1.0, 2.0, 3.0]
      output_vector = vector_type.call(input_vector)
      expect(output_vector).to eq(input_vector)
    end
  end

  describe 'when vector column with nil values' do
    it 'replaces nil values with zeros' do
      input_vector = [1.0, nil, 3.0]
      output_vector = vector_type.call(input_vector)
      expect(output_vector).to eq([1.0, 0.0, 3.0])
    end
  end

  describe 'with ::ROM::SQL::Postgres::Types::Vector' do
    it 'casts a vector preserving the input values' do
      pg_vector_type = ::ROM::SQL::Postgres::Types::Vector.new

      input_vector = [1.0, 2.0, 3.0]
      output_vector = pg_vector_type.call(input_vector)

      expect(output_vector).to eq(input_vector)
    end

    it 'inserts and retrieves vector data' do
      vector_type = ROM::SQL::Postgres::Types::Vector.new
      vector_type.instance_variable_set('@binary', true)
    end
  end

  describe 'BinaryEncoder::Vector' do
    let(:binary_vector_type) do
      described_class.new.tap { |vector_type| vector_type.instance_variable_set('@binary', true) }
    end

    it 'encodes a vector' do
      input_vector = [1.0, 2.0, 3.0]
      encoded_vector = binary_vector_type.dump(input_vector)
      expect(encoded_vector).to be_a(String)
    end
  end
end
