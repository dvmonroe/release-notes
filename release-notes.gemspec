# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "release/notes/version"

Gem::Specification.new do |spec|
  spec.name          = "release-notes"
  spec.version       = Release::Notes::VERSION
  spec.authors       = ["Drew Monroe"]
  spec.email         = ["dvmonroe6@gmail.com"]

  spec.summary       = "Automated release notes for your project"
  spec.description   = "Generate automated release notes for any project"
  spec.homepage      = "http://github.com/dvmonroe/release-notes"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|config)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r(^exe/)) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", ">= 5.0", "< 6.1"
  spec.add_dependency "thor", "~> 0.20"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "pry", "~> 0.12.2"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rubocop", "~> 0.61.0"
end
