# frozen_string_literal: true
require 'release/notes/version'
require 'release/notes/configuration'
require 'release/notes/file_writer'
require 'release/notes/linker'
require 'release/notes/git'
require 'release/notes/logger'

require 'release/notes/railtie' if defined?(Rails)

module Release
  module Notes
    class Update
      attr_accessor :logger

      def initialize
        @logger = Logger.new
      end

      def run
        logger.fetch_and_write_log
      end
    end

    def self.root
      File.expand_path('../..', __FILE__)
    end
  end
end
