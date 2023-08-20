# frozen_string_literal: true
# typed: true

module RubyBot
  # Module holding useful utils
  module Utils
    def self.constantinize(namespace, name)
      Object.const_get("#{namespace}::#{name.split('_').map(&:capitalize).join}")
    end
  end
end
