# frozen_string_literal: true

require "active_support"
require "active_support/core_ext/time"

require "release/notes/date_format"
require "release/notes/link"
require "release/notes/pretty_print"

require "release/notes/version"
require "release/notes/configuration"
require "release/notes/git"
require "release/notes/system"

require "release/notes/write"
require "release/notes/log"

require "release/notes/railtie" if defined?(Rails)

module Release
  module Notes
    class << self
      def generate
        log.perform
      end

      def log
        Release::Notes::Log.new
      end

      def root
        File.expand_path("..", __dir__)
      end
    end
  end
end
