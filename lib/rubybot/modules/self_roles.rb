# frozen_string_literal: true
# typed: true

module RubyBot
  module Modules
    # Module holding commands for user-assignable roles
    module SelfRoles
      extend Discordrb::Commands::CommandContainer

      command(
        :create_role_menu, description: 'Creates a select menu for roles', required_permissions: [:manage_roles]
      ) do |event, *message|
        message = message.nil? ? '' : message.join(' ')
        event.channel.send_message(
          message, false, nil, nil, nil, nil,
          Discordrb::Webhooks::View.new do |builder|
            builder.row do |r|
              r.role_select(custom_id: 'role_select', placeholder: 'Please select your roles', max_values: 10)
            end
          end
        )
      end

      RubyBot.bot.role_select do |event|
        server_id = event.channel.server.id
        blacklisted_roles = RubyBot::DB.find_self_roles_blacklist_roles(server_id).map(&:role_id)

        if event.values.any? { |value| blacklisted_roles.include? value.id }
          embed = Discordrb::Webhooks::Embed.new
          embed.color = '#ff0000'
          embed.title = 'Blocked'
          embed.description = 'One ore more roles you selected are blacklisted.'
          embed.add_field name: 'Blacklisted Roles', value: blacklisted_roles.map { |role| "<@&#{role}>" }.join("\n")
          event.interaction.respond(
            embeds: [embed],
            ephemeral: true
          )
          next
        end
        selected_roles = event.values.map(&:id)
        current_roles = event.user.roles.map(&:id)

        new_roles = current_roles.select { |role| blacklisted_roles.include? role }
        new_roles.push(*selected_roles)

        event.user.set_roles(new_roles)

        embed = Discordrb::Webhooks::Embed.new
        embed.color = '#00ff00'
        embed.title = 'Success'
        embed.description = 'Successfully added you to the selected roles!'
        embed.add_field name: 'New Roles', value: new_roles.map { |role| "<@&#{role}>" }.join("\n")
        event.interaction.respond(
          embeds: [embed],
          ephemeral: true
        )
      end
    end
  end
end
