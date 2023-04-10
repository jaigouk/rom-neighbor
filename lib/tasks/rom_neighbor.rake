# frozen_string_literal: true

require 'rom-sql'
require 'fileutils'

namespace :db do
  namespace :rom_neighbor do
    desc 'Create a migration to add cube or vector extension'
    task :extension, [:extension] => :environment do |_, args|
      extension = args[:extension]
      raise 'extension must be cube or vector' unless %w[cube vector].include?(extension)

      migration_name = "create_#{extension}_extension"
      migration_template = <<~TEMPLATE
        ROM::SQL.migration do
          up do
            run 'CREATE EXTENSION #{extension};'
          end

          down do
            run 'DROP EXTENSION #{extension};'
          end
        end
      TEMPLATE

      # Ensure the db/migrate directory exists
      FileUtils.mkdir_p('db/migrate')

      migration_file = "db/migrate/#{Time.now.strftime('%Y%m%d%H%M%S')}_#{migration_name}.rb"
      File.write(migration_file, migration_template)
    end
  end
end
