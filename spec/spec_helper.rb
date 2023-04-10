# frozen_string_literal: true

require_relative "../lib/rom_neighbor"
require 'byebug'

Dir[File.join('spec', 'support', '**', '*.rb')].each { |file| require File.expand_path(file) }
