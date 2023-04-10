# frozen_string_literal: true

require 'rake'
require 'rom-sql'
require 'fileutils'

RSpec.describe 'db:rom_neighbor:extension' do
  before :all do
    Rake.application.rake_require('tasks/rom_neighbor')
    Rake::Task.define_task(:environment)
  end

  describe 'db:rom_neighbor:extension' do
    let(:extension) { 'cube' }
    let(:migration_dir) { 'db/migrate' }
    let(:rake_task) { Rake::Task['db:rom_neighbor:extension'] }

    before do
      FileUtils.rm_rf(migration_dir)
      rake_task.reenable
    end

    after do
      FileUtils.rm_rf(migration_dir)
    end

    it 'creates the migration directory if it does not exist' do
      expect(File.directory?(migration_dir)).to be_falsey
      rake_task.invoke(extension)
      expect(File.directory?(migration_dir)).to be_truthy
    end

    it 'creates a migration file for the specified extension' do
      rake_task.invoke(extension)
      migration_files = Dir.glob(File.join(migration_dir, '*_create_cube_extension.rb'))
      expect(migration_files.length).to eq(1)
      expect(File.read(migration_files.first)).to match(/CREATE EXTENSION #{extension};/)
      expect(File.read(migration_files.first)).to match(/DROP EXTENSION #{extension};/)
    end
  end
end
