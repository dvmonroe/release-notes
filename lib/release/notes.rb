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
require "release/notes/with_configuration"

require "release/notes/write"
require "release/notes/log"

require "release/notes/railtie" if defined?(Rails)

module Release
  module Notes
    class Update
      attr_reader :logger

      def initialize
        @options = Release::Notes.configuration
        @logger = Release::Notes::Log.new @options
      end

      def run
        logger.perform
      end
    end

    def self.root
      File.expand_path("..", __dir__)
    end
  end
end
