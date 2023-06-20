# frozen_string_literal: true

require 'bundler/setup'
require 'discordrb'
require 'yaml'
require 'rmagick'
require 'mathematical'

config = YAML.load_file('config.yml')
bot = Discordrb::Commands::CommandBot.new(
  token: config['token'],
  client_id: config['client_id'],
  prefix: config['prefix'],
  ignore_bots: config['ignore_bots']
)

status = [
  'prefix: r!'
]

bot.ready do
  bot.game = status.sample.to_s
  sleep 180
  redo
end

load 'commands/commands.rb'

bot.include! Commands

bot.command(:list_modules, description: 'List all loaded modules') do |event|
  mod = Dir.entries('commands/').select { |f| File.file? File.join('commands/', f) }
  event.respond mod.to_s
end

bot.command(:reload_module, description: 'Reloads a module') do |event, arg|
  load "commands/#{arg}"
  event.respond "Reloaded module #{arg} in: #{Time.now - event.timestamp} seconds."
end
bot.run
