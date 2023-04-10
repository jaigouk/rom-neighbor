# frozen_string_literal: true
require 'bundler/setup'
require 'rom-sql'
require 'pgvector'

require_relative "../lib/rom_neighbor"

require 'byebug'

ROM::SQL::Types::Nominal = ROM::Types::Nominal

Dir[File.join('spec', 'support', '**', '*.rb')].each { |file| require File.expand_path(file) }
