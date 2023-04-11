# frozen_string_literal: true

module RomHelper
  def rom_config
    RSpec.configuration.rom_config
  end

  def rom_connection
    rom_config.gateways[:default].connection
  end
end

RSpec.configure do |config|
  config.include RomHelper
end
