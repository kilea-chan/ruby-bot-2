# frozen_string_literal: true
# typed: true

module RubyBot
  # Loading and unloading modules
  module ModuleHandler
    require 'lucky_case/string'
    require_relative 'utils'

    MODULES_DIR = "#{__dir__}/modules".freeze

    def self.load_all
      load_modules(list_all_modules)
    end

    def self.load_modules(modules)
      modules.each do |m|
        # next if m.include?('event')

        load_module(MODULES_DIR, m)
      end
    end

    def self.load_module(path, mod)
      load "#{path}/#{mod.snake_case}#{'.rb' unless mod.include?('.rb')}"
      RubyBot.logger.info("Loading module: #{mod}")
      RubyBot.bot.include! Utils.constantinize('RubyBot::Modules', mod.split('.')[0].pascal_case)
    end

    def self.list_all_modules
      Dir.entries(MODULES_DIR).select { |f| File.file? File.join(MODULES_DIR, f) }
    end

    def self.list_loaded_modules
      RubyBot::Modules.constants.sort.map(&:to_s)
    end

    RubyBot.bot.command(:modules, description: 'List all available modules') do |event|
      embed = Discordrb::Webhooks::Embed.new
      loaded_modules = list_loaded_modules
      all_modules = list_all_modules.map { |mod| mod.split('.')[0].pascal_case }
      embed.title = 'Modules'
      embed.add_field name: 'Loaded Modules', value: loaded_modules.join("\n")
      embed.add_field name: 'Unloaded Modules', value: all_modules.reject { |mod| loaded_modules.include? mod }.join("\n")
      embed.color = '#00ff00'

      event.send_embed '', embed.to_hash
    end

    RubyBot.bot.command(:unload, description: 'Unloads a loaded module') do |event, mod|
      # Removing all defined commands before removing the module itself
      RubyBot::Modules.const_get(mod).commands.each_key do |command|
        RubyBot.bot.remove_command(command)
      end
      RubyBot::Modules.send(:remove_const, mod)
      event.respond "Unloaded module: #{mod}"
    end

    RubyBot.bot.command(:reload, description: 'Reloads a module') do |event, mod|
      case mod
      when 'all'
        load_modules(list_all_modules)
        event.respond "Reloaded all modules in: #{Time.now - event.timestamp} seconds."
      when 'loaded'
        load_modules(list_loaded_modules)
        event.respond "Reloaded loaded modules in: #{Time.now - event.timestamp} seconds."
      else
        load_module(MODULES_DIR, mod)
        event.respond "Reloaded module #{mod} in: #{Time.now - event.timestamp} seconds."
      end
    end
  end
end
