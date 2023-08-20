# frozen_string_literal: true
# typed: true

module RubyBot
  module Modules
    # Module holding moderational commands
    module Moderational
      extend Discordrb::Commands::CommandContainer

      command(
        :kick, min_args: 2, description: 'Kicks one or more users', usage: 'kick *users reason'
      ) do |event, *users, reason|
        permission_result = check_permission(event, :kick_members)
        return permission_result unless permission_result.nil?

        bot_roles = event.bot.member(event.server, event.bot.profile.id).roles.sort_by(&:position)
        author_roles = event.author.roles.sort_by(&:position)

        resolved_users = []

        users.each do |user|
          validated_user = check_user(event, user)
          return "User: #{user} is unknown." if validated_user.nil?

          user_roles = event.bot.member(event.server, validated_user.id).roles.sort_by(&:position)

          role_result = check_roles(validated_user, user_roles.last.position, bot_roles.last.position, author_roles.last.position)
          return role_result unless role_result.nil?

          resolved_users.push "<@#{validated_user.id}>"

          kick_ban_timeout(event, :kick, validated_user, nil, reason)
        end

        event.send_embed do |embed|
          embed.color = '#00ff00'
          embed.title = 'Kick Confirmation'
          embed.add_field name: 'Kicked Users', value: resolved_users.join(', ')
        end
      end

      command(
        :ban, min_args: 3, description: 'Bans one or more users', usage: 'ban *users days reason'
      ) do |event, *users, days, reason|
        permission_result = check_permission(event, :ban_members)
        return permission_result unless permission_result.nil?

        bot_roles = event.bot.member(event.server, event.bot.profile.id).roles.sort_by(&:position)
        author_roles = event.author.roles.sort_by(&:position)

        resolved_users = []

        users.each do |user|
          validated_user = check_user(event, user)
          user_roles = event.bot.member(event.server, validated_user.id).roles.sort_by(&:position)

          role_result = check_roles(validated_user, user_roles.last.position, bot_roles.last.position, author_roles.last.position)
          return role_result unless role_result.nil?

          resolved_users.push "<@#{validated_user.id}>"

          kick_ban_timeout(event, :ban, validated_user, days, reason)
        end

        event.send_embed do |embed|
          embed.color = '#00ff00'
          embed.title = 'Ban Confirmation'
          embed.add_field name: 'Banned Users', value: resolved_users.join(', ')
        end
      end

      command(
        :timeout, min_args: 2, description: 'Timeouts one or more users', usage: 'timeout *users reason'
      ) do |event, *users, time|
        permission_result = check_permission(event, :moderate_members)
        return permission_result unless permission_result.nil?

        bot_roles = event.bot.member(event.server, event.bot.profile.id).roles.sort_by(&:position)
        author_roles = event.author.roles.sort_by(&:position)

        resolved_users = []
        timedout_until = Time.now + time.to_i

        users.each do |user|
          validated_user = check_user(event, user)
          user_roles = event.bot.member(event.server, validated_user.id).roles.sort_by(&:position)

          role_result = check_roles(validated_user, user_roles.last.position, bot_roles.last.position, author_roles.last.position)
          return role_result unless role_result.nil?

          resolved_users.push "<@#{validated_user.id}>"

          kick_ban_timeout(event, :timeout, validated_user, timedout_until, nil)
        end

        event.send_embed do |embed|
          embed.color = '#00ff00'
          embed.title = 'Timeout Confirmation'
          embed.add_field name: 'Timed out users', value: resolved_users.join(', ')
          embed.add_field name: 'Timed out until', value: timedout_until.to_s
        end
      end

      def self.check_user(event, user)
        if user.match(/<@[0-9]*>/)
          event.bot.parse_mention(user)
        elsif user.match(/^[0-9]*$/)
          event.bot.user(user.to_i) unless user.to_i >= 9_223_372_036_854_775_807
        end
      end

      def self.check_permission(event, type)
        return "You don't have permission to use this command." unless event.author.permission?(type)
        return "RubyBot doesn't have permission." unless event.bot.profile.on(event.server).permission?(type)
      end

      def self.check_roles(user, user_position, bot_position, author_position)
        return "RubyBot is not allowed to perform that action on: <@#{user.id}>." if user_position >= bot_position
        return "You are not allowed to perform that action on: <@#{user.id}>." if user_position >= author_position
      end

      def self.kick_ban_timeout(event, type, user, day_or_time, reason)
        case type
        when :kick
          event.server.kick(user, reason)
        when :ban
          event.server.ban(user, day_or_time, reason)
        when :timeout
          event.bot.member(event.server, user.id).communication_disabled_until = (day_or_time)
        end
      end
    end
  end
end
