# frozen_string_literal: true
# typed: true

module RubyBot
  # Loading and unloading modules
  module ModuleHandler
    require 'lucky_case/string'
    require_relative 'utils'
    require_relative 'data/db'

    MODULES_DIR = "#{__dir__}/modules".freeze

    def self.load_all
      load_modules(list_all_modules)
    end

    def self.load_enabled
      load_modules(list_enabled_modules)
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

    def self.list_enabled_modules
      RubyBot::DB.find_modules_by_status(true).map(&:module_name)
    end

    def self.list_loaded_modules
      RubyBot::Modules.constants.sort.map(&:to_s)
    end

    RubyBot.bot.command(:modules, description: 'List all modules') do |event|
      embed = Discordrb::Webhooks::Embed.new
      loaded_modules = list_loaded_modules
      all_modules = list_all_modules.map { |mod| mod.split('.')[0].pascal_case }
      enabled_modules = list_enabled_modules

      module_list = all_modules.map do |m|
        { name: m, enabled: (enabled_modules.include?(m) ? '✅' : '❌'), loaded: (loaded_modules.include?(m) ? '✅' : '❌') }
      end

      embed.title = 'Modules'
      embed.color = '#00ff00'
      embed.add_field name: 'Name', value: module_list.map { |val| val[:name] }.join("\n"), inline: true
      embed.add_field name: 'Enabled', value: module_list.map { |val| val[:enabled] }.join("\n"), inline: true
      embed.add_field name: 'Loaded', value: module_list.map { |val| val[:loaded] }.join("\n"), inline: true

      event.send_embed '', embed.to_hash
    end

    RubyBot.bot.command(:unload, description: 'Unloads a loaded module', help_available: false) do |event, mod|
      break unless event.user.id == RubyBot.config['admin_id']

      # Removing all defined commands before removing the module itself
      RubyBot::Modules.const_get(mod).commands.each_key do |command|
        RubyBot.bot.remove_command(command)
      end
      RubyBot::Modules.send(:remove_const, mod)
      event.respond "Unloaded module: #{mod}"
    end

    RubyBot.bot.command(:reload, description: 'Reloads a module', help_available: false) do |event, mod|
      break unless event.user.id == RubyBot.config['admin_id']

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

    RubyBot.bot.command(:enable, description: 'Enables a module', help_available: false) do |event, mod|
      break unless event.user.id == RubyBot.config['admin_id']

      db_mod = RubyBot::DB.find_module(mod)

      if db_mod.nil?
        new_mod = RubyBot::DB::Modules.new(module_name: mod, enabled: true)
        RubyBot::DB.save_module(new_mod)
      else
        db_mod.enabled = true
        RubyBot::DB.save_module(db_mod)
      end

      event.respond "Enabled module: #{mod}"
    end

    RubyBot.bot.command(:disable, description: 'Disables a module', help_available: false) do |event, mod|
      break unless event.user.id == RubyBot.config['admin_id']

      db_mod = RubyBot::DB.find_module(mod)

      if db_mod.nil?
        new_mod = RubyBot::DB::Modules.new(module_name: mod, enabled: false)
        RubyBot::DB.save_module(new_mod)
      else
        db_mod.enabled = false
        RubyBot::DB.save_module(db_mod)
      end

      event.respond "Disabled module: #{mod}"
    end
  end
end
