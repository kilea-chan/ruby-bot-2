# frozen_string_literal: true
# typed: true

module RubyBot
  module Modules
    # Module holding commands to manage events
    module EventCommands
      extend Discordrb::Commands::CommandContainer

      require_relative '../data/db'

      command(:set_log_channels, description: 'Sets the channel the bot logs to', help_available: false) do |event, *channels|
        channels.each do |channel|
          RubyBot::DB.save_log_channel(event.server.id, channel)
        end
        event.send_embed do |embed|
          embed.color = '#00ff00'
          embed.description = 'Saved channels'
        end
      end

      command(:list_log_channels, description: 'Lists log channels configured for this server', help_available: false) do |event|
        channels = RubyBot::DB.find_log_channels(event.server.id).map(&:channel_id)
        event.send_embed do |embed|
          embed.color = '#00ff00'
          channels.each
          embed.add_field name: 'Log Channels', value: channels.map { |channel| "<##{channel}>" }.join("\n")
        end
      end

      command(:remove_log_channels,
              description: 'Removes log channels configured for this server', help_available: false) do |event, *channels|
        channels.each do |channel|
          RubyBot::DB.remove_log_channel(event.server.id, channel)
        end
        event.send_embed do |embed|
          embed.color = '#00ff00'
          embed.description = 'Removed channels'
        end
      end

      command(:set_log_blacklist_channels, description: 'Blacklists a channel from logging', help_available: false) do |event, *channels|
        channels.each do |channel|
          RubyBot::DB.save_log_blacklist_channel(event.server.id, channel)
        end
        event.send_embed do |embed|
          embed.color = '#00ff00'
          embed.description = 'Saved channels'
        end
      end

      command(:list_log_blacklist_channels, description: 'Lists all blacklisted channels', help_available: false) do |event|
        channels = RubyBot::DB.find_log_blacklist_channels(event.server.id).map(&:channel_id)
        event.send_embed do |embed|
          embed.color = '#00ff00'
          channels.each
          embed.add_field name: 'Blacklisted Channels', value: channels.map { |channel| "<##{channel}>" }.join("\n")
        end
      end

      command(:remove_log_blacklist_channels, description: 'Removes log channels configured for this server', help_available: false) do |event, *channels|
        channels.each do |channel|
          RubyBot::DB.remove_log_blacklist_channel(event.server.id, channel)
        end
        event.send_embed do |embed|
          embed.color = '#00ff00'
          embed.description = 'Removed channels'
        end
      end

      command(:blacklist_string, description: 'Marks messages containing <String> for deletion') do |event, *content|
        content.each do |text|
          RubyBot::DB.save_forbidden_strings(event.server.id, text)
        end
        event.send_embed do |embed|
          embed.color = '#00ff00'
          embed.description = 'Saved Strings'
        end
      end

      command(:show_blacklist, description: 'Lists all forbidden Strings') do |event|
        content = RubyBot::DB.find_forbidden_strings(event.server.id).map(&:text)
        event.send_embed do |embed|
          embed.color = '#00ff00'
          embed.add_field name: 'Forbidden Strings', value: content.map(&:to_s).join("\n")
        end
      end
    end
  end
end
