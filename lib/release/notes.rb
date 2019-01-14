# frozen_string_literal: true

require "active_support"
require "active_support/core_ext/time"

require "release/notes/configurable"
require "release/notes/date_formatter"
require "release/notes/link"
require "release/notes/pretty_print"

require "release/notes/version"
require "release/notes/configuration"
require "release/notes/git"
require "release/notes/system"

require "release/notes/write"
require "release/notes/log"
require "release/notes/tag"
require "release/notes/commits"

require "release/notes/railtie" if defined?(Rails)
require "release/notes/install" unless defined?(Rails)

module Release
  module Notes
    NEWLINE = "\n"

    class << self
      def generate
        log.perform
      end

      def root
        File.expand_path("..", __dir__)
      end

      private

      def log
        Log.new
      end
    end
  end
end
