# Release::Notes

[![Build Status](https://travis-ci.org/dvmonroe/release-notes.svg?branch=master)](https://travis-ci.org/dvmonroe/release-notes)
[![Code Climate](https://codeclimate.com/github/dvmonroe/release-notes/badges/gpa.svg)](https://codeclimate.com/github/dvmonroe/release-notes)
[![Test Coverage](https://codeclimate.com/github/dvmonroe/release-notes/badges/coverage.svg)](https://codeclimate.com/github/dvmonroe/release-notes/coverage)  

Release notes for the stakeholders.

Release::Notes is a small automation script around your git flow. The gem is
intended to help increase visability to all team members and stakeholders by
consolidating and documenting changes made to your code base for a given
production deployment.

Release::Notes is different than a changelog. If your looking for something geared
more towards github issues or logging all dev work, I would suggest you look
instead at something like [github-changelog-generator](https://github.com/skywinder/github-changelog-generator).


## Getting Started

Add this line to your application's Gemfile:

```ruby
gem 'release-notes'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install release-notes


## Usage

TODO: coming soon

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dvmonroe/release-notes. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

