# frozen_string_literal: true

require "fakefs/spec_helpers"
require "simplecov"
require "pry"

SimpleCov.start do
  add_filter "/spec/"
end

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "release/notes"

::Dir.glob(::File.expand_path("../support/**/*.rb", __FILE__)).each { |f| require_relative f }

def restore_config
  Release::Notes.configuration = nil
  Release::Notes.configure {}
end

RSpec.configure do |config|
  config.include FakeFS::SpecHelpers
  config.mock_with :rspec do |mocks|
    mocks.syntax = %i(expect should)
  end
end
