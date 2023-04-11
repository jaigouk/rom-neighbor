# frozen_string_literal: true

require 'pg'
require 'pgvector'
require 'rom-sql'

RSpec.configure do |config|
  config.add_setting :pg_vector_connection

  config.before(:suite) do
    database_url = ENV['DATABASE_URL'] || 'postgres://user:password@localhost:5432/rom_neighbor_test'

    conn = PG.connect(database_url)
    registry = PG::BasicTypeRegistry.new.define_default_types
    Pgvector::PG.register_vector(registry)
    conn.type_map_for_results = PG::BasicTypeMapForResults.new(conn, registry: registry)

    config.add_setting :rom_config
    rom_config = ROM::Configuration.new(:sql, database_url)
    RSpec.configuration.rom_config = rom_config
  end
end
