# frozen_string_literal: true

module Release
  module Notes
    class Configuration
      # The absolute path of your generated log.
      # Defaults to `./RELEASE_NOTES.md`.
      # @return [String]
      attr_accessor :output_file

      # The absolute path of the temporary generated log.
      # Defaults to `./release-notes.tmp.md`.
      # @return [String]
      attr_accessor :temp_file

      # Determines whether to print commits with more than one parent.
      # Defaults to `false`. For more, see
      # [Git Log Docs](https://git-scm.com/docs/git-log)
      # @return [Boolean]
      attr_accessor :include_merges

      # Match the regular expression limiting patterns without regard to letter case
      # when printing your git log.
      # Defaults to `true`. For more, see
      # [Git Log Docs](https://git-scm.com/docs/git-log)
      # @return [Boolean]
      attr_accessor :ignore_case

      # Consider the limiting patterns to be extended regular expressions patterns
      # when printing your git log.
      # Defaults to `true`. For more, see
      # [Git Log Docs](https://git-scm.com/docs/git-log)
      # @return [Boolean]
      attr_accessor :extended_regex

      # Controls the headers that will be used for your tags
      # Defaults to `tag`.
      # @return [String]
      attr_accessor :header_title

      # Controls the labels grepped for in your commit subjects that will
      # be add under you bug title
      # Defaults to `%w(Fix Update)`.
      # @return [Array]
      attr_accessor :bug_labels

      # Controls the labels grepped for in your commit subjects that will
      # be add under you feature title
      # Defaults to `%w(Add Create)`.
      # @return [Array]
      attr_accessor :feature_labels

      # Controls the labels grepped for in your commit subjects that will
      # be add under you miscellaneous title
      # Defaults to `%w(Refactor)`.
      # @return [Array]
      attr_accessor :misc_labels

      # Controls the title used in your generated log for all bugs listed
      # Defaults to `**Fixed bugs:**`.
      # @return [String]
      attr_accessor :bug_title

      # Controls the title used in your generated log for all features listed
      # Defaults to `**Implemented enhancements:**`.
      # @return [String]
      attr_accessor :feature_title

      # Controls the title used in your generated log for all misc commits listed
      # Defaults to `**Miscellaneous:**`.
      # @return [String]
      attr_accessor :misc_title

      # Controls whether all logs that do not match the other labels are listed
      # Defaults to `false`
      # @return [Boolean]
      attr_accessor :log_all

      # Controls the title used in your generated log for all commits listed
      # Defaults to `**Other:**`.
      # @return [String]
      attr_accessor :log_all_title

      # The labels grepped for in your commit subject that you want to linkify.
      # The index within the array must match the index for the site
      # in `:link_to_humanize` and `:link_to_sites`.
      # Defaults to `[]`.
      # @return [Array]
      attr_accessor :link_to_labels

      # The humanized output that you'd like to represent the associated `:link_to_label`
      # The index within the array must match the index for the site
      # in `:link_to_label` and `:link_to_sites`.
      # Defaults to `[]`.
      # @return [Array]
      attr_accessor :link_to_humanize

      # The url for the site that you'd like to represent the associated `:link_to_label`
      # The index within the array must match the index for the site
      # in `:link_to_label` and `:link_to_humanize`.
      # Defaults to `[]`.
      # @return [Array]
      attr_accessor :link_to_sites

      # Sets the timezone that should be used for setting the date.
      # Defaults to `America/New_York`. For more, see
      # [ActiveSupport Time Zones](http://api.rubyonrails.org/classes/ActiveSupport/TimeZone.html)
      # @return [String]
      attr_accessor :timezone

      # Controls whether your commit subject labels should be removed from the final
      # ouput of your message on the generated log.
      # Defaults to `false`.
      # @return [Boolean]
      attr_accessor :prettify_messages

      # Controls whether to rewrite the output file or append to it.
      # Defaults to `false`.
      # @return [Boolean]
      attr_accessor :force_rewrite

      # If a commit message contains words that match more than
      # one group of labels as defined in your configuration, the output
      # will only contain the commit once.
      # Defaults to `true`.
      # @return [Boolean]
      attr_accessor :single_label

      # Controls what will be passed to the format flag in `git for-each-ref`
      # Defaults to `tag`.
      # @return [String]
      attr_accessor :for_each_ref_format

      # Determines whether to use the last two tags to
      # find commits for the output or if this gem should just
      # find all commits after previous tag
      # Defaults to `true`.
      # @return [Boolean]
      attr_accessor :update_release_notes_before_tag

      # The newest tag that should be used as the header title
      # if updating the release notes before the actual tag
      # is pushed.
      # Defaults to empty string.
      # @return [String]
      attr_accessor :newest_tag

      def initialize
        @output_file                      = "./RELEASE_NOTES.md"
        @temp_file                        = "./release-notes.tmp.md"
        @include_merges                   = false
        @ignore_case                      = true
        @extended_regex                   = true
        @header_title                     = "tag"
        @bug_labels                       = %w(Fix Update)
        @feature_labels                   = %w(Add Create)
        @misc_labels                      = %w(Refactor)
        @bug_title                        = "**Fixed bugs:**"
        @feature_title                    = "**Implemented enhancements:**"
        @misc_title                       = "**Miscellaneous:**"
        @log_all_title                    = "**Other**"
        @log_all                          = false
        @link_to_labels                   = %w()
        @link_to_humanize                 = %w()
        @link_to_sites                    = %w()
        @timezone                         = "America/New_York"
        @prettify_messages                = false
        @force_rewrite                    = false
        @single_label                     = true
        @for_each_ref_format              = "tag"
        @update_release_notes_before_tag  = true
        @newest_tag                       = ""
      end

      instance_methods.each do |meth|
        define_method("#{meth}?") do
          return send(meth) == true if !!send(meth) == send(meth) # rubocop:disable Style/DoubleNegation

          raise NotBoolean, "Configuration##{meth} does not return a Boolean and
            therefore, has no predicate method."
        end
      end

      # @return [String]
      def header_title_type
        @header_title.match?(/^[tag|date]+$/) ? @header_title : "tag"
      end

      # @return [String]
      def merge_flag
        include_merges? ? "" : "--no-merges"
      end

      # @return [String]
      def regex_type
        extended_regex? ? "-E" : ""
      end

      # @return [String]
      def grep_insensitive_flag
        ignore_case? ? "-i" : ""
      end

      # @return [String]
      def bugs
        @bugs ||= generate_regex(@bug_labels)
      end

      # @return [String]
      def features
        @features ||= generate_regex(@feature_labels)
      end

      # @return [String]
      def misc
        @misc ||= generate_regex(@misc_labels)
      end

      # @return [String]
      def all_labels
        @all_labels ||= generate_regex(@bug_labels + @feature_labels + @misc_labels)
      end

      # @return [Boolean]
      def release_notes_exist?
        File.exist? output_file
      end

      # @return [Boolean]
      def link_commits?
        link_to_labels.present? && link_to_humanize.present? &&
          link_to_sites.present?
      end

      private

      # @api private
      # Using over Regexp.union
      def generate_regex(arr)
        arr.join("|").insert(0, "(").insert(-1, ")")
      end
    end

    # @return [Release::Notes::Configuration] Release::Notes's current configuration
    def self.configuration
      @configuration ||= Configuration.new
    end

    # Set Release::Notes's configuration
    # @param config [Release::Notes::Configuration]
    def self.configuration=(config)
      @configuration = config
    end

    # Modify Release::Notes's current configuration
    # @yieldparam [Release::Notes] config current Release::Notes config
    # ```
    # Release::Notes.configure do |config|
    #   config.routes = false
    # end
    # ```
    def self.configure
      yield configuration
    end
  end
end
