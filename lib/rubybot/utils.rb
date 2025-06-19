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

# Adding additional functioanlity to strings
class String
  # ruby mutation methods have the expectation to return self if a mutation occurred, nil otherwise. (see http://www.ruby-doc.org/core-1.9.3/String.html#method-i-gsub-21)
  def to_snakecase!
    gsub!(/(.)([A-Z])/, '\1_\2')
    downcase!
  end

  def to_snakecase
    dup.tap(&:to_snakecase!)
  end

  def to_camelcase!
    # split('_').map(&:capitalize).join
    capitalize!
    gsub!(/_(\w)/) { ::Regexp.last_match(1).upcase }
  end

  def to_camelcase
    dup.tap(&:to_camelcase!)
  end
end
