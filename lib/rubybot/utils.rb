# frozen_string_literal: true
# typed: true

module RubyBot
  # Module holding useful utils
  module Utils
    def self.constantinize(name)
      Object.const_get(name.split('_').map(&:capitalize).join)
    end
  end
end
