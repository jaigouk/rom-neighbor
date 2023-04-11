# frozen_string_literal: true
require 'bundler/setup'
require 'rom-sql'
require 'pgvector'

require 'byebug'

ROM::SQL::Types::Nominal = ROM::Types::Nominal

require_relative './support/rom_helper'

Dir[File.join('spec', 'support', '**', '*.rb')].each { |file| require File.expand_path(file) }
