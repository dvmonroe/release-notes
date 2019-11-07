# Release Notes

## 4.2.0

**Fixed bugs:**

- [Rake dependency] Fix dependency for install script

## 4.1.0

**Fixed bugs:**

- Update deps to allow rails < 7 (#80)
- Update github-changelog-generator link in README (#81)

## 4.0.1

**Fixed bugs:**

- Remove non existent rake task load

## 4.0.0

**Implemented enhancements:**

- Add tests around install.rake and change 'puts' to stderr.puts

## v4.0.0.pre

**Implemented enhancements:**

- Update README remove git workflow recomendations for now
- Add in new Release::Notes::Cmd
- Add in predicate methods for Configuration

**Fixed bugs:**

- Fix cops
- Remove backslash for linked labels
- Remove rake task. Just support binstub usage
- Fix up github templates

**Miscellaneous:**

- Another README update
- Update README and template in generator

## v3.1.0

**Implemented enhancements:**

- Add configurable option for format when grabbing git tags

## v3.0.0

**Implemented enhancements:**

- [Refactor] Log.rb for readability/maintainability
- [Refactor] DateFormat(ter) and it's usage in log.rb
- [Refactor] Delegate all config related methods in one module

**Fixed bugs:**

- Update documentation
- [Refactor] prettify as class/ remove module

**Miscellaneous:**

- administration updates
- [Refactor] System as a class with class & instance methods
- Update our own release notes and label outputs

## v2.0.0

**Implemented enhancements:**

- Add our own release notes
- Add travis test for ruby 2.6.0
- Fix error when tracking commits
- Add ruby gems doc link
- Add integration test for file that already exists
- Add confiugration to not dupe commits
- Add first round of integration tests for default configuration :tada:
- Fix fact that we aren't writing first tags' commits

**Fixed bugs:**

- Yet another fix on bin/publish. Close block
- Fix cops
- Fix bin/publish to actually update version.rb
- Remove extraneous binstub from last commit
- Fix cognitive method complexity in log.rb
- Remove note about multiple commits.
- Fix link to CONTRIBUTING.md in README
- Remove empty (duped) messages from array
- Fix cops
- Fix force_rewrite bug to allow appending new commits to old relase notes
- Remove :nocov: labels now that we have integration testing
- Fix git tags reference

**Miscellaneous:**

- Update code of conduct to 1.4.0 of contributor covenant
- Refactor - set prettify_messages to false by default

## v1.3.0

**Implemented enhancements:**

- Add Configuration#header_title
- Add logo
- Remove System#invert_log ;B

**Fixed bugs:**

- Amend rubocop config & remove inline disables

**Miscellaneous:**

- More updates to README
- Update README to explain how grep works

## v1.2.1

**Fixed bugs:**

- Fix cognitive complexity of split_words ;F

## v1.2.0

**Implemented enhancements:**

- Output the line if not prettifying (#35)

**Fixed bugs:**

- Fix log_all option and invert-grep ;B
- Fix travis - actually run rspec tests ;B

## v1.1.2

**Miscellaneous:**

- Update binstub to support config file in config/ folder

## v1.1.1

**Fixed bugs:**

- Fix README

**Miscellaneous:**

- Update README
- Update binstub to check non-rails config file

## v1.1.0

**Implemented enhancements:**

- Light refactoring and add binstub and non-rails install

## v1.0.1

**Fixed bugs:**

- Update README.md
- Remove environment from rake task
- Fix contributing.md

## v1.0.0

**Implemented enhancements:**

- Updates to README, CONTRIBUTING and add bin/test

**Fixed bugs:**

- Fix linking/writing of none linked lines and frozen string modification
- Fix guard clause for rubocop

**Miscellaneous:**

- Update README and install template

## v1.0.0.pre

**Implemented enhancements:**

- Add log_all option for configuration
- Add force_rewrite option to configuration
- Fix linking not adding the issue number correctly
- Add GH templates
- Add test around puts on rake task
- Add rubocop & fix cops
- ignore .ruby-version since it's irrelevant and add different rubies to travis
- Update README

**Fixed bugs:**

- Fix cops and depreciation warnings
- Fix spelling error
- Reduce cyclomatic complexity of Write.rb
- Refactor link.rb and increase test coverage
- Remove extra new line on output
- Remove extra header underline on output md file
- fix readme typo

**Miscellaneous:**

- Update README
- ruby version update -> 2.5.3

## v0.1.0

**Implemented enhancements:**

- Minor updates to layout of gem
- add docs badge to readme
- add yard config
- WIP adding test coverage to code climate
- Add badges to README
- Add some initial tests

**Miscellaneous:**

- Update prettify class
- update readme
- Update to linking commit messages
- more readme updates
- update readme
