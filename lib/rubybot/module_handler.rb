# frozen_string_literal: true
# typed: true

module RubyBot
  # Loading and unloading modules
  module ModuleHandler
    require_relative 'utils'

    MODULES_DIR = "#{__dir__}/modules".freeze

    def self.load_all
      modules = list_all_modules
      modules.each do |m|
        load_module(MODULES_DIR, m)
      end
    end

    def self.load_module(path, mod)
      load "#{path}/#{mod.to_snakecase}"
      RubyBot.logger.info("Loading module: #{mod}")
      RubyBot.bot.include! Utils.constantinize('RubyBot::Modules', mod.split('.')[0])
    end

    def self.list_all_modules
      Dir.entries(MODULES_DIR).select { |f| File.file? File.join(MODULES_DIR, f) }
    end

    RubyBot.bot.command(:list_modules, description: 'List all available modules') do |event|
      embed = Discordrb::Webhooks::Embed.new
      loaded_modules = RubyBot::Modules.constants.sort.map(&:to_s)
      all_modules = list_all_modules.map { |mod| mod.split('.')[0].to_camelcase }

      embed.title = 'Modules'
      embed.add_field name: 'Loaded Modules', value: loaded_modules.join("\n")
      embed.add_field name: 'Unloaded Modules', value: all_modules.reject { |mod| loaded_modules.include? mod }.join("\n")
      embed.color = '#00ff00'

      event.send_embed '', embed.to_hash
    end

    RubyBot.bot.command(:unload_module, description: 'Unloads a loaded module') do |event, mod|
      # Removing all defined commands before removing the module itself
      RubyBot::Modules.const_get(mod).commands.each_key do |command|
        RubyBot.bot.remove_command(command)
      end
      event.respond "Unloaded module: #{RubyBot::Modules.send(:remove_const, mod)}"
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
