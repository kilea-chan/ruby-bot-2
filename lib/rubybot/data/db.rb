# frozen_string_literal: true
# typed: true

module RubyBot
  # Module for managing DB related stuff
  module DB
    require 'active_record'

    db_config = RubyBot.config['database']

    ActiveRecord::Base.establish_connection(db_config)

    # Message cache table
    class MessageCache < ActiveRecord::Base
      self.table_name = 'message_cache'
    end

    # Where to send the logs
    class EventLogChannels < ActiveRecord::Base
      self.table_name = 'event_log_channels'
    end

    # Channels to be ignored
    class EventLogBlacklistChannels < ActiveRecord::Base
      self.table_name = 'event_log_blacklist_channels'
    end

    # Roles to be ignored
    class SelfRolesBlacklist < ActiveRecord::Base
      self.table_name = 'self_roles_blacklist'
    end

    # Modlues table
    class Modules < ActiveRecord::Base
      self.table_name = 'modules'
    end

    # rubocop:disable Metrics/ParameterLists
    def self.cache_message(message_id, channel_id, server_id, user_id, message_time, content, attachments)
      MessageCache.create(
        message_id:,
        channel_id:,
        server_id:,
        user_id:,
        message_time:,
        content:,
        attachments:
      )
    end
    # rubocop:enable Metrics/ParameterLists

    def self.find_message(message_id, channel_id, server_id)
      MessageCache.find_by(message_id:, channel_id:, server_id:)
    end

    def self.update_message(new_message)
      new_message.save
    end

    def self.find_log_channels(server_id)
      EventLogChannels.where(server_id:)
    end

    def self.find_log_blacklist_channels(server_id)
      EventLogBlacklistChannels.where(server_id:)
    end

    def self.save_log_channel(server_id, channel_id)
      EventLogChannels.create(server_id:, channel_id:)
    end

    def self.save_log_blacklist_channel(server_id, channel_id)
      EventLogBlacklistChannels.create(server_id:, channel_id:)
    end

    def self.remove_log_channel(server_id, channel_id)
      EventLogChannels.delete_by(server_id:, channel_id:)
    end

    def self.remove_log_blacklist_channel(server_id, channel_id)
      EventLogBlacklistChannels.delete_by(server_id:, channel_id:)
    end

    def self.find_self_roles_blacklist_roles(server_id)
      SelfRolesBlacklist.where(server_id:)
    end

    def self.save_self_roles_blacklist_role(server_id, role_id)
      SelfRolesBlacklist.create(server_id:, role_id:)
    end

    def self.remove_self_roles_blacklist_role(server_id, role_id)
      SelfRolesBlacklist.delete_by(server_id:, role_id:)
    end

    def self.find_modules_by_status(enabled)
      Modules.where(enabled:)
    end

    def self.find_module(module_name)
      Modules.find_by(module_name:)
    end

    def self.find_modules
      Modules.all
    end

    def self.save_module(mod)
      mod.save
    end
  end
end
