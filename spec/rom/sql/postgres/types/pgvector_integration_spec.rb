# frozen_string_literal: true

require 'spec_helper'
require 'pgvector'
require 'rom/sql/postgres/types/vector'

RSpec.describe ROM::SQL::Postgres::Types::Vector do
  describe 'Pgvector Integration' do
    let(:conn) { RSpec.configuration.pg_vector_connection }

    before do
      conn.exec("CREATE EXTENSION IF NOT EXISTS vector")
      conn.exec("DROP TABLE IF EXISTS items")
      conn.exec("CREATE TABLE items (id serial primary key, embedding vector)")
    end

    after do
      conn.exec("DROP TABLE items")
      # conn.close
    end

    context 'when using binary encoding' do
      before do
        input_vector = [1.5, 2, 3]
        conn.exec_params("INSERT INTO items (embedding) VALUES ($1), (NULL)", [input_vector])
      end

      it 'retrieves vector data' do
        vector_type = ROM::SQL::Postgres::Types::Vector.new
        vector_type.instance_variable_set('@binary', true)

        res = conn.exec("SELECT * FROM items ORDER BY id").to_a
        retrieved_vector = vector_type.load(res[0]["embedding"])
        expect(retrieved_vector).to eq([1.5, 2, 3])
        expect(res[1]["embedding"]).to be_nil
      end
    end

    # context 'when using text encoding' do
    #   before do
    #     input_vector = [1.5, 2, 4]
    #     conn.exec_params("INSERT INTO items (embedding) VALUES ('{#{input_vector.join(',')}}'), (NULL)")
    #   end

    #   it 'inserts and retrieves vector data' do
    #     vector_type = ROM::SQL::Postgres::Types::Vector.new
    #     vector_type.instance_variable_set('@binary', false)

    #     res = conn.exec("SELECT * FROM items_second ORDER BY id").to_a
    #     retrieved_vector = vector_type.load(res[0]["embedding"])
    #     expect(retrieved_vector).to eq([1.5, 2, 3])
    #     expect(res[1]["embedding"]).to be_nil
    #   end
    # end
  end
end
