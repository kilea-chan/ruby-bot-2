# frozen_string_literal: true
# typed: true

# Generic module holding misc commands
module Generic
  extend Discordrb::Commands::CommandContainer

  command(:ping, description: 'Pings the bot.') do |event|
    uptime = "#{Process.clock_gettime(Process::CLOCK_MONOTONIC) - RubyBot.launch_time} seconds"

    embed = Discordrb::Webhooks::Embed.new

    embed.title = 'Pong!'
    embed.add_field name: 'Uptime', value: uptime, inline: true
    embed.add_field name: 'Latency', value: '', inline: true
    embed.add_field name: 'Bot Version', value: RubyBot::VERSION
    embed.add_field name: 'Discordrb Version', value: Discordrb::VERSION
    embed.add_field name: 'Ruby Version', value: RUBY_DESCRIPTION
    embed.color = '#00ff00'

    msg = event.send_embed '', embed.to_hash

    embed.fields.map { |f| f.value = "#{Time.now - event.timestamp} seconds" if f.name == 'Latency' }

    msg.edit '', embed.to_hash
  end

  command(:shutdown, help_available: false) do |event|
    break unless event.user.id == 285_454_085_631_508_484

    event.respond 'Shutting down..'
    exit
  end
end
