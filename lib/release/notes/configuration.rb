# frozen_string_literal: true
module Release
  module Notes
    class Configuration
      attr_accessor :output_file
      attr_accessor :include_merges
      attr_accessor :case_insensitive_grep
      attr_accessor :extended_regex
      attr_accessor :log_format
      attr_accessor :bug_labels
      attr_accessor :feature_labels
      attr_accessor :misc_labels
      attr_accessor :bug_title
      attr_accessor :feature_title
      attr_accessor :misc_title
      attr_accessor :link_labels
      attr_accessor :site_links
      attr_accessor :by_release
      # should be a string as such: "2016-09-19"
      attr_accessor :first_commit_date
      attr_accessor :timezone

      attr_reader   :midnight
      attr_reader   :before_midnight

      def initialize
        @output_file           = './RELEASENOTES.md'
        @include_merges        = false
        @case_insensitive_grep = true
        @log_format            = '-%s'
        @extended_regex        = true
        @bug_labels            = %w(Fix Update)
        @feature_labels        = %w(Add Create)
        @misc_labels           = %w(Refactor)
        @bug_title             = '**Fixed bugs:**'
        @feature_title         = '**Implemented enhancements:**'
        @misc_title            = '**Miscellaneous:**'
        @link_labels           = []
        @site_links            = []
        @by_release            = true
        @first_commit_date     = nil
        @timezone              = 'America/New_York'
        @midnight              = '00:00'
        @before_midnight       = '23:59'
      end

      def include_merges?
        @include_merges ? '' : '--no-merges'
      end

      def regex_type
        @extended_regex ? '-E' : ''
      end

      def grep_insensitive?
        @case_insensitive_grep ? '-i' : ''
      end

      def by_release?
        @by_release
      end

      def bugs
        @bugs ||= generate_regex(@bug_labels)
      end

      def features
        @features ||= generate_regex(@feature_labels)
      end

      def misc
        @misc ||= generate_regex(@misc_labels)
      end

      def all_labels
        @all_labels ||= generate_regex(@bug_labels + @feature_labels + @misc_labels)
      end

      def release_notes_exist?
        File.exist? output_file
      end

      private

      def generate_regex(array)
        array.join('|').insert(0, '(').insert(-1, ')')
      end
    end

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.configuration=(config)
      @configuration = config
    end

    def self.configure
      yield configuration
    end
  end
end
