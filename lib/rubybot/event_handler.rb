# frozen_string_literal: true
# typed: true

module RubyBot
  # Loading and unloading modules
  module EventHandler
    require_relative 'utils'

    MODULES_DIR = "#{__dir__}/events".freeze

    def self.load_all
      modules = list_available_modules
      modules.each do |m|
        load_module(MODULES_DIR, m)
      end
    end

    def self.load_module(path, mod)
      load "#{path}/#{mod}"
      RubyBot.logger.info("Loading module: #{mod}")
      RubyBot.bot.include! Utils.constantinize(mod.split('.')[0])
    end

    def self.list_available_modules
      Dir.entries(MODULES_DIR).select { |f| File.file? File.join(MODULES_DIR, f) }
    end
  end
end
