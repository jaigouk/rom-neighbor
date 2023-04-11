require 'rom'
require 'database_cleaner-sequel'

require 'rom-sql'
require 'dotenv'

Dotenv.load('.env.test')

config = ROM::Configuration.new(:sql, ENV['DATABASE_URL'])
rom = ROM.container(config)

unless rom.gateways[:default].connection.table_exists?(:test_table)
  rom.gateways[:default].connection.create_table(:test_table) do
    primary_key :id
    String :name
  end
end

DatabaseCleaner.allow_remote_database_url = true

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner[:sequel].db = rom.gateways[:default].connection
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning { example.run } unless example.metadata[:skip_db_cleaner]
  end
end
