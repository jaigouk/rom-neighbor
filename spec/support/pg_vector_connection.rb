# frozen_string_literal: true

require 'pg'
require 'pgvector'

RSpec.configure do |config|
  config.before(:suite) do
    database_url = ENV['DATABASE_URL'] || 'postgres://user:password@localhost:5432/rom_neighbor_test'
    conn = PG.connect(database_url)

    unless conn.exec("SELECT 1 FROM pg_extension WHERE extname = 'vector'").any?
      conn.exec('CREATE EXTENSION IF NOT EXISTS vector')
    end

    conn.exec('DROP TABLE IF EXISTS items')
    conn.exec('CREATE TABLE items (id bigserial primary key, embedding vector(3))')

    registry = PG::BasicTypeRegistry.new.define_default_types
    Pgvector::PG.register_vector(registry)
    conn.type_map_for_queries = PG::BasicTypeMapForQueries.new(conn, registry: registry)
    conn.type_map_for_results = PG::BasicTypeMapForResults.new(conn, registry: registry)
  end
end
