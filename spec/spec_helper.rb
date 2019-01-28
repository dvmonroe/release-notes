# frozen_string_literal: true

require "simplecov"
require "pry"

SimpleCov.start do
  add_filter "/spec/"
end

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "release/notes"
require "active_support/testing/time_helpers"
Time.zone = "America/New_York"

unless $LOAD_PATH.include?(File.expand_path("support", __dir__))
  $LOAD_PATH.unshift(File.expand_path("support", __dir__))
end

def restore_config
  Release::Notes.configuration = nil
  Release::Notes.configure {}
end

def delete_files
  FileUtils.rm_f "./RELEASE_NOTES.md"
  FileUtils.rm_f "./release-notes.tmp.md"
end

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.syntax = %i(expect should)
  end

  config.include ActiveSupport::Testing::TimeHelpers

  config.after(:each) { restore_config }
  config.after(:all) { delete_files }
end
