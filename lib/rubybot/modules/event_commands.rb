# frozen_string_literal: true
# typed: true

module RubyBot
  module Modules
    # Module holding commands to manage events
    module EventCommands
      extend Discordrb::Commands::CommandContainer

      require_relative '../data/db'

      command(:set_log_channels, description: 'Sets the channel the bot logs to') do |event, *channels|
        channels.each do |channel|
          RubyBot::DB.save_log_channel(event.server.id, channel)
        end
        event.send_embed do |embed|
          embed.color = '#00ff00'
          embed.description = 'Saved channels'
        end
      end

      command(:list_log_channels, description: 'Lists log channels configured for this server') do |event|
        channels = RubyBot::DB.find_log_channels(event.server.id).map(&:channel_id)
        event.send_embed do |embed|
          embed.color = '#00ff00'
          channels.each
          embed.add_field name: 'Log Channels', value: channels.map { |channel| "<##{channel}>" }.join("\n")
        end
      end

      command(:remove_log_channels,
              description: 'Removes log channels configured for this server') do |event, *channels|
        channels.each do |channel|
          RubyBot::DB.remove_log_channel(event.server.id, channel)
        end
        event.send_embed do |embed|
          embed.color = '#00ff00'
          embed.description = 'Removed channels'
        end
      end

      command(:set_log_blacklist_channels, description: 'Blacklists a channel from logging') do |event, *channels|
        channels.each do |channel|
          RubyBot::DB.save_log_blacklist_channel(event.server.id, channel)
        end
        event.send_embed do |embed|
          embed.color = '#00ff00'
          embed.description = 'Saved channels'
        end
      end

      command(:list_log_blacklist_channels, description: 'Lists all blacklisted channels') do |event|
        channels = RubyBot::DB.find_log_blacklist_channels(event.server.id).map(&:channel_id)
        event.send_embed do |embed|
          embed.color = '#00ff00'
          channels.each
          embed.add_field name: 'Blacklisted Channels', value: channels.map { |channel| "<##{channel}>" }.join("\n")
        end
      end

      # rubocop:disable Layout/LineLength
      command(:remove_log_blacklist_channels, description: 'Removes log channels configured for this server') do |event, *channels|
        channels.each do |channel|
          RubyBot::DB.remove_log_blacklist_channel(event.server.id, channel)
        end
        event.send_embed do |embed|
          embed.color = '#00ff00'
          embed.description = 'Removed channels'
        end
      end
      # rubocop:enable Layout/LineLength
    end
  end
end
