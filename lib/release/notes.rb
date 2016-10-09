# frozen_string_literal: true
require 'active_support/core_ext/time'

require 'release/notes/version'
require 'release/notes/configuration'
require 'release/notes/file_writer'
require 'release/notes/linker'
require 'release/notes/git'
require 'release/notes/logger'
require 'release/notes/system'
require 'release/notes/date_formatter'
require 'release/notes/prettify'

require 'release/notes/railtie' if defined?(Rails)

module Release
  module Notes
    class Update
      attr_reader :logger

      def initialize
        @config = Release::Notes.configuration
        @logger = Release::Notes::Logger.new(@config)
      end

      def run
        logger.copy_logs
      end
    end

    def self.root
      File.expand_path('../..', __FILE__)
    end
  end
end
