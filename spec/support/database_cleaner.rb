require 'rom'
require 'database_cleaner-sequel'

require 'rom-sql'
require 'dotenv'

Dotenv.load('.env.test')
require 'pg'

def create_database_if_not_exists
  # Extract the database name from the DATABASE_URL
  uri = URI.parse(ENV['DATABASE_URL'])
  db_name = uri.path[1..-1]

  # Connect to the default PostgreSQL database
  conn = PG.connect(dbname: 'postgres')

  # Check if the database exists
  result = conn.exec("SELECT 1 FROM pg_database WHERE datname='#{db_name}'")

  if result.count == 0
    # Database does not exist, create it using the `createdb` command
    system("createdb #{db_name}")
  end

  # Close the connection to the default PostgreSQL database
  conn.close
end

create_database_if_not_exists

config = ROM::Configuration.new(:sql, ENV['DATABASE_URL'])
rom = ROM.container(config)

unless rom.gateways[:default].connection.table_exists?(:test_table)
  rom.gateways[:default].connection.create_table(:test_table) do
    primary_key :id
    String :name
  end
end

DatabaseCleaner[:sequel, db: rom.gateways[:default].connection]
DatabaseCleaner.allow_remote_database_url = true

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning { example.run } unless example.metadata[:skip_db_cleaner]
  end
end
