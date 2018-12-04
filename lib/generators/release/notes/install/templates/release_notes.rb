# frozen_string_literal: true

Release::Notes.configure do |config|
  # The absolute path of your generated log.
  # Defaults to `./RELEASE_NOTES.md`.
  # @return [String]
  # config.output_file = "./RELEASE_NOTES.md"

  # The absolute path of the temporary generated log.
  # Defaults to `./release-notes.tmp.md`.
  # @return [String]
  # config.temp_file = "./release-notes.tmp.md"

  # Determines whether to print commits with more than one parent.
  # Defaults to `false`. For more, see
  # [Git Log Docs](https://git-scm.com/docs/git-log)
  # @return [Boolean]
  # config.include_merges = false

  # Match the regular expression limiting patterns without regard to letter case
  # when printing your git log.
  # Defaults to `true`. For more, see
  # [Git Log Docs](https://git-scm.com/docs/git-log)
  # @return [Boolean]
  # config.ignore_case = true

  # Allows you to specify what information you want to print from your git log
  # Defaults to `%s` for subject. For more, see
  # [Git Log Docs](https://git-scm.com/docs/git-log)
  # @return [String]
  # config.log_format = "- %s"

  # Consider the limiting patterns to be extended regular expressions patterns
  # when printing your git log.
  # Defaults to `true`. For more, see
  # [Git Log Docs](https://git-scm.com/docs/git-log)
  # @return [Boolean]
  # config.extended_regex = true

  # Controls the header used in your generated log for all tags
  # Defaults to `false`.
  # @return [Boolean]
  # config.by_tag_date = false

  # Allows you to specify what information you want to print from your git log
  # Defaults to `%s` for subject. For more, see
  # [Git Log Docs](https://git-scm.com/docs/git-log)
  # @return [String]
  # config.bug_labels = %w(Fix Update)

  # Controls the labels grepped for in your commit subjects that will
  # be add under you feature title
  # Defaults to `%w(Add Create)`.
  # @return [Array]
  # config.feature_labels = %w(Add Create)

  # Controls the labels grepped for in your commit subjects that will
  # be add under you miscellaneous title
  # Defaults to `%w(Refactor)`.
  # @return [Array]
  # config.misc_labels = %w(Refactor)

  # Controls the title used in your generated log for all bugs listed
  # Defaults to `**Fixed bugs:**`.
  # @return [String]
  # config.bug_title = "**Fixed bugs:**"

  # Controls the title used in your generated log for all features listed
  # Defaults to `**Implemented enhancements:**`.
  # @return [String]
  # config.feature_title = "**Implemented enhancements:**"

  # Controls the title used in your generated log for all misc commits listed
  # Defaults to `**Miscellaneous:**`.
  # @return [String]
  # config.misc_title = "**Miscellaneous:**"

  # Controls the title used in your generated log for all commits listed
  # Defaults to `**Other:**`.
  # @return [String]
  # config.log_all_title = "**Other:**"

  # Controls whether all logs that do not match the other labels are listed
  # Defaults to `false`
  # @return [Boolean]
  # config.log_all = false

  # The labels grepped for in your commit subject that you want to linkify.
  # The index within the array must match the index for the site
  # in `:link_to_humanize` and `:link_to_sites`.
  # Defaults to `[]`.
  # @return [Array]
  # config.link_to_labels = %w()

  # The humanized output that you'd like to represent the associated `:link_to_label`
  # The index within the array must match the index for the site
  # in `:link_to_label` and `:link_to_sites`.
  # Defaults to `[]`.
  # @return [Array]
  # config.link_to_humanize = %w()

  # The url for the site that you'd like to represent the associated `:link_to_label`
  # The index within the array must match the index for the site
  # in `:link_to_label` and `:link_to_humanize`.
  # Defaults to `[]`.
  # @return [Array]
  # config.link_to_sites = %w()

  # Sets the timezone that should be used for setting the date.
  # Defaults to `America/New_York`. For more, see
  # [ActiveSupport Time Zones](http://api.rubyonrails.org/classes/ActiveSupport/TimeZone.html)
  # @return [String]
  # config.timezone = "America/New_York"

  # Controls whether your commit subject labels should be removed from the final
  # ouput of your message on the generated log.
  # Defaults to `true`.
  # @return [Boolean]
  # config.prettify_messages = true

  # Controls whether to rewrite the output file or append to it.
  # Defaults to `false`.
  # @return [Boolean]
  # config.force_rewrite = false
end
