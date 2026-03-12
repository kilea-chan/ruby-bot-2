# frozen_string_literal: true
# typed: true

module RubyBot
  module Events
    # Module for message filtering
    module EventFilter
      extend Discordrb::EventContainer

      require_relative '../data/db'

      message do |event|
        server_id = event.server.id
        forbidden_strings = RubyBot::DB.find_forbidden_strings(server_id).map(&:text)

        next unless forbidden_strings.any? { |text| event.content.include? text }

        event.message.delete
      end
    end
  end
end
