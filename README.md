# Release::Notes

[![Build Status](https://travis-ci.org/dvmonroe/release-notes.svg?branch=master)](https://travis-ci.org/dvmonroe/release-notes)
[![Code Climate](https://codeclimate.com/github/dvmonroe/release-notes/badges/gpa.svg)](https://codeclimate.com/github/dvmonroe/release-notes)
[![Test Coverage](https://codeclimate.com/github/dvmonroe/release-notes/badges/coverage.svg)](https://codeclimate.com/github/dvmonroe/release-notes/coverage)
[![Inline docs](http://inch-ci.org/github/dvmonroe/release-notes.svg?branch=master)](http://inch-ci.org/github/dvmonroe/release-notes)

Release notes for the stakeholders.

Release::Notes is a small wrapper around your project's git log. The gem is
intended to help increase visability to all team members and stakeholders with
automated documentation of important changes made to your code base for a given production
deployment based on tags and labels in your commit messages.

Release::Notes is different than a changelog. It's meant for situations where other
team members (non-devs) in your organization need to know about key changes
to the production software.  If your looking for a comprehnsive changelog that
reflects resolved github issues or logging all merges to your project, I would
suggest you look at something else like
[github-changelog-generator](https://github.com/skywinder/github-changelog-generator).


## Getting Started

Add this line to your application's Gemfile:

```ruby
gem 'release-notes'
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install release-notes
```

After you install Release::Notes, if you're using with rails, you can run the generator:

```sh
$ rails generate release:notes:install
```

This Release::Notes generator creates an initializer file to allow further configuration.

If you're not in a rails project you can create the file yourself.


## Configure

Override any of these defaults in `config/initializers/release_notes.rb`:

```ruby
Release::Notes.configure do |config|
  config.output_file = './RELEASENOTES.md'
  config.temp_file = './release-notes.tmp.md'
  config.include_merges = false
  config.case_insensitive_grep = true
  config.log_format = '- %s'
  config.extended_regex = true
  config.bug_labels = %w(Fix Update)
  config.feature_labels = %w(Add Create)
  config.misc_labels = %w(Refactor)
  config.bug_title = '**Fixed bugs:**'
  config.feature_title = '**Implemented enhancements:**'
  config.misc_title = '**Miscellaneous:**'
  config.link_labels = %w()
  config.site_links = %w()
  config.by_release = true
  config.first_commit_date = nil
  config.timezone = 'America/New_York'
end
```

For more information about each individual setting checkout Release::Notes's
[config docs](http://www.rubydoc.info/github/dvmonroe/release-notes/master/Release/Notes/Configuration).

## Usage

### Git Worklow

Release::Notes works best with a rebase workflow. General rebase benefits include:

* One clear commit per feature, bug or miscellaneous addition to the codebase  
* Commits in one logical time manner  

By default configuration, Release::Notes ignores merges. Along with rebasing, Release::Notes relies 
only on the commit message. Thus, it's important to craft concise and
meaningful commit messages with longer bodies as needed for larger feature additions or bug fixes.

For more information about a rebase workflow or crafting solid commit messages
check out the following links

*[Commit Messages](http://chris.beams.io/posts/git-commit/)  
*[Git Rebase Workflow](https://git-scm.com/book/en/v2/Git-Branching-Rebasing)

### Deploying with Capistrano

If using Rails, a rake task is included and would be best utilized within your deploy script.

If not on rails, but using rake, you can easily craft your own rake task.  At the very least calling

```ruby
Release::Notes::Update.new.run
```
is the only instance that needs to be instantiated and invoked.

A sample capistrano production file might look something like this:

```ruby
# config/deploy/production.rb
server 'the_name_for_my_server', user: 'deploy', roles: %w{app web}

set :application, 'my_app'
set :deploy_to, '/var/www/my_app'


namespace :deploy do
  before :starting, :update_release_notes

  task :update_release_notes do
    sh 'RAILS_ENV=development bin/rake "update_release_notes:run"'
  end
end
```

Useful information can be found here regarding the
[capistrano flow](http://capistranorb.com/documentation/getting-started/flow/).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dvmonroe/release-notes. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

