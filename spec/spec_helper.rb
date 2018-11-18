# frozen_string_literal: true

require "simplecov"
require "pry"
SimpleCov.start

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "release/notes"
require "aruba/rspec"

::Dir.glob(::File.expand_path("../support/**/*.rb", __FILE__)).each { |f| require_relative f }

def restore_config
  Release::Notes.configuration = nil
  Release::Notes.configure {}
end
