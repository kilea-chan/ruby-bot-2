# frozen_string_literal: true
# typed: true

module RubyBot
  module Events
    # Module for discord logging
    module EventLog
      extend Discordrb::EventContainer

      require_relative '../data/db'

      message_delete do |event|
        server_id = event.channel.server.id
        message_id = event.id
        channel_id = event.channel.id

        log_channels = RubyBot::DB.find_log_channels(server_id).map(&:channel_id)
        log_blacklist_channels = RubyBot::DB.find_log_blacklist_channels(server_id).map(&:channel_id)

        # Is the channel blacklisted? Break if it is
        next if log_blacklist_channels.include? channel_id

        # Check if a log channel is defined, break if not
        next if log_channels.nil?

        cached_message = RubyBot::DB.find_message(message_id, channel_id, server_id)
        next if cached_message.nil?

        author_id = cached_message.user_id
        author = event.bot.user(author_id).name
        content = cached_message.content

        log_channels.each do |channel|
          event.bot.channel(channel).send_embed do |embed|
            embed.title = 'Message deleted'
            embed.color = '#ff0000'
            embed.add_field name: 'Author', value: author, inline: true
            embed.add_field name: 'Author ID', value: author_id, inline: true
            embed.add_field name: 'Message', value: content
          end
        end
      end

      message_edit do |event|
        author = event.author.username
        author_id = event.author.id
        content = event.content
        message_id = event.message.id
        channel_id = event.channel.id
        server_id = event.server.id

        log_channels = RubyBot::DB.find_log_channels(server_id).map(&:channel_id)
        log_blacklist_channels = RubyBot::DB.find_log_blacklist_channels(server_id).map(&:channel_id)

        # Is the channel blacklisted? Break if it is
        next if log_blacklist_channels.include? channel_id

        # Check if a log channel is defined, break if not
        next if log_channels.nil?

        cached_message = RubyBot::DB.find_message(message_id, channel_id, server_id)
        next if cached_message.nil?

        log_channels.each do |channel|
          event.bot.channel(channel).send_embed do |embed|
            embed.title = 'Message edited'
            embed.color = '#fc8403'
            embed.add_field name: 'Author', value: author, inline: true
            embed.add_field name: 'Author ID', value: author_id, inline: true
            embed.add_field name: 'Original Message', value: cached_message.content
            embed.add_field name: 'New Message', value: content
          end
        end

        cached_message.content = content
        RubyBot::DB.update_message(cached_message)
      end

      message do |event|
        message_id = event.message.id
        author_id = event.author.id
        channel_id = event.channel.id
        server_id = event.server.id
        content = event.content
        attachments = event.message.attachments.join(' ')
        timestamp = event.timestamp

        log_blacklist_channels = RubyBot::DB.find_log_blacklist_channels(server_id).map(&:channel_id)

        # Is the channel blacklisted? Break if it is
        next if log_blacklist_channels.include? channel_id

        RubyBot::DB.cache_message(message_id, channel_id, server_id, author_id, timestamp, content, attachments)
      end
    end
  end
end
