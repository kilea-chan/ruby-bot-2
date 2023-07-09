# frozen_string_literal: true
# typed: true

module RubyBot
  # Loading and unloading modules
  module ModuleHandler
    require_relative 'utils'

    MODULES_DIR = "#{__dir__}/modules".freeze

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

    RubyBot.bot.command(:list_modules, description: 'List all loaded modules') do |event|
      event.respond list_available_modules.to_s
    end

    RubyBot.bot.command(:reload_module, description: 'Reloads a module') do |event, mod|
      load_module(MODULES_DIR, mod)
      event.respond "Reloaded module #{mod} in: #{Time.now - event.timestamp} seconds."
    end

    RubyBot.bot.command(:reload_all, description: 'Reloads all modules') do |event|
      load_all
      event.respond "Reloaded all modules in: #{Time.now - event.timestamp} seconds."
    end
  end
end
