# frozen_string_literal: true

Release::Notes.configure do |config|
  config.output_file = "./CHANGELOG.md"
  # config.temp_file = './release-notes.tmp.md'
  # config.include_merges = false
  # config.ignore_case = true
  # config.log_format = '- %s'
  # config.extended_regex = true
  # config.header_title = "tag"
  config.bug_labels = %w(Fix Remove)
  config.feature_labels = %w(Add Create Refactor Update Ammend)
  config.misc_labels = %w(Bump Utilize)
  # config.bug_title = '**Fixed bugs:**'
  # config.feature_title = '**Implemented enhancements:**'
  # config.misc_title = '**Miscellaneous:**'
  # config.log_all_title = '**Other:**'
  # config.log_all = false
  # config.link_to_labels = %w()
  # config.link_to_humanize = %w()
  # config.link_to_sites = %w()
  # config.timezone = 'America/New_York'
  # config.prettify_messages = false
  # config.force_rewrite = false
  # config.single_label = true
end
