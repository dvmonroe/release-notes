# frozen_string_literal: true
require 'release/notes/version'
require 'release/notes/configuration'
require 'release/notes/file_writer'
require 'release/notes/linker'
require 'release/notes/git'
require 'release/notes/updater'

require 'release/notes/railtie' if defined?(Rails)

module Release
  module Notes
    def self.update
      Updater.new.run
    end
  end
end
