# frozen_string_literal: true
# typed: true

require 'bundler/setup'
require 'discordrb'
require 'yaml'

# Main entrypoint
module RubyBot
  class << self
    # attr_accessor :bot
    attr_reader :logger, :config, :bot, :launch_time
  end

  @logger = Discordrb::LOGGER

  @config = YAML.load_file('config.yml')

  @bot = Discordrb::Commands::CommandBot.new(
    token: @config['token'],
    client_id: @config['client_id'],
    prefix: @config['prefix'],
    ignore_bots: @config['ignore_bots']
  )

  @launch_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

  status = [
    'prefix: r!'
  ]

  @bot.ready do
    bot.game = status.sample.to_s
    sleep 180
    redo
  end

  at_exit { @bot.stop }

  def self.run!
    @bot.run
  end
end

require_relative 'rubybot/version'
require_relative 'rubybot/module_handler'
require_relative 'rubybot/event_handler'

RubyBot::ModuleHandler.load_all
RubyBot::EventHandler.load_all

RubyBot.run!
