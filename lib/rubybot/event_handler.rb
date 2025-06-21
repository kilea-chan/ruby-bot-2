# frozen_string_literal: true
# typed: true

module RubyBot
  # Loading and unloading modules
  module EventHandler
    require 'lucky_case/string'
    require_relative 'utils'

    MODULES_DIR = "#{__dir__}/events".freeze

    def self.load_all
      load_modules(list_all_modules)
    end

    def self.load_modules(modules)
      modules.each do |m|
        load_module(MODULES_DIR, m)
      end
    end

    def self.load_module(path, mod)
      load "#{path}/#{mod.snake_case}#{'.rb' unless mod.include?('.rb')}"
      RubyBot.logger.info("Loading module: #{mod}")
      RubyBot.bot.include! Utils.constantinize('RubyBot::Events', mod.split('.')[0].pascal_case)
    end

    def self.list_all_modules
      Dir.entries(MODULES_DIR).select { |f| File.file? File.join(MODULES_DIR, f) }
    end
  end
end
