# frozen_string_literal: true

Release::Notes.configure do |config|
  config.output_file = "./RELEASE_NOTES.md"
  config.temp_file = "./release-notes.tmp.md"
  config.include_merges = false
  config.ignore_case = true
  config.log_format = "- %s"
  config.extended_regex = true
  config.bug_labels = %w(Fix ;B)
  config.feature_labels = %w(Add Create ;F Refactor Update)
  config.misc_labels = %w(;M)
  config.bug_title = "**Fixed bugs:**"
  config.feature_title = "**Implemented enhancements:**"
  config.misc_title = "**Miscellaneous:**"
  config.log_all_title = "**Other:**"
  config.log_all = true
  config.link_to_labels = %w()
  config.link_to_humanize = %w()
  config.link_to_sites = %w()
  config.timezone = "America/New_York"
  config.prettify_messages = false
  config.force_rewrite = false
end
