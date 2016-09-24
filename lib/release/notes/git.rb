# frozen_string_literal: true
module Release
  module Notes
    class Git
      attr_reader :config, :date_formatter

      delegate :log_format, :grep_insensitive?, :regex_type,
               :features, :bugs, :misc, :feature_title, :bug_title,
               :include_merges?, :output_file, :first_commit_date, to: :config

      delegate :date_since, :date_until, :date_since_midnight,
               :date_until_midnight, to: :date_formatter

      def initialize(config, dates)
        @config = config
        @date_formatter = dates
      end

      def log(label)
        "git log --grep='#{label}' #{regex_type} #{grep_insensitive?}" \
                 " #{include_merges?} --format='#{log_format}'" \
                 " --since='#{date_since}'" \
                 " --until='#{date_until}'"
      end

      def sorted_log(label)
        "git log --grep='#{label}' #{regex_type} #{grep_insensitive?}" \
                 " #{include_merges?} --format='%cd' --date=short" \
                 "--since='#{date_since_midnight}'" \
                 "--until='#{date_until_midnight}' | sort -u -r"
      end

      def self.last_tag
        'git describe --abbrev=0 --tags'
      end

      def self.tag_date(tag)
        "git log -1 --format=%ai #{tag}"
      end

      def self.first_commit
        'git log --format=%cd --date=short --reverse | head -1'
      end
    end
  end
end
