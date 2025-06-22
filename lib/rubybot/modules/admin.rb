# frozen_string_literal: true
# typed: true

module RubyBot
  module Modules
    # Module holding moderational commands
    module Admin
      extend Discordrb::Commands::CommandContainer

      $SAFE = 4

      # rubocop:disable Security/Eval
      command(:eval, help_available: false) do |event, *arg|
        break unless event.user.id == RubyBot.config['admin_id']

        begin
          eval arg.join(' ')
        rescue StandardError
          'An error occurred..'
        end
      end
      # rubocop:enable Security/Eval
      command(:shutdown, help_available: false) do |event|
        break unless event.user.id == RubyBot.config['admin_id']

        event.respond 'Shutting down..'
        exit
      end
    end
  end
end
