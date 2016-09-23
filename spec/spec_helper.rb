# frozen_string_literal: true
require 'simplecov'
require "codeclimate-test-reporter"
SimpleCov.start

CodeClimate::TestReporter.configure do |config|
  config.logger.level = Logger::WARN
end
CodeClimate::TestReporter.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'release/notes'
require 'aruba/rspec'
require 'pry-byebug'

::Dir.glob(::File.expand_path('../support/**/*.rb', __FILE__)).each { |f| require_relative f }

def restore_config
  Release::Notes.configuration = nil
  Release::Notes.configure {}
end
