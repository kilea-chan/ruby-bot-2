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
        break unless event.user.id == 285_454_085_631_508_484

        begin
          eval arg.join(' ')
        rescue StandardError
          'An error occurred..'
        end
      end
      # rubocop:enable Security/Eval
    end
  end
end
