# frozen_string_literal: true
module Release
  module Notes
    class Git
      attr_reader :config

      def initialize(config)
        @config = config
      end

      def log(label)
        `git log --grep="#{label}" "#{regex_flag}" "#{case_flag}" \
                 "#{no_merges}" --format="#{format}" \
                 --since="#{since_when}" \
                 --until="#{until_when}"`
      end

      def sorted_log(label)
        `git log --grep="#{label}" "#{regex_flag}" "#{case_flag}" \
                 "#{no_merges}" --format="%cd" --date=short \
                 --since="#{since_when_broad}" \
                 --until="#{until_when_broad}" | sort -u -r`
      end

      private

      def last_tag
        `git describe --abbrev=0 --tags`
      end

      def last_tag_date_time
        `git log -1 --format=%ai #{last_tag}`
      end

      def first_commit
        config.first_commit_date ||=
          `git log --format=%cd --date=short --reverse | head -1`
      end

      # Parse the date and time from the last tag.
      def since_when
        return format_dt last_tag_date if notes_already_created
        format_dt first_commit_date_parsed, '00:00'
      end

      def since_when_broad
        return format_dt last_tag_date, '00:00' if notes_already_created
        format_dt first_commit_date_parsed, '00:00'
      end

      def last_tag_date
        DateTime.parse last_tag_date_time
      end

      def first_commit_date_parsed
        DateTime.parse first_commit
      end

      # Time right now as we prepare our deploy.
      def until_when
        format_dt Time.now
      end

      def until_when_broad
        format_dt Time.now, '23:59'
      end

      def format_dt(exec, time = '%R')
        exec.strftime("%F '#{time}'")
      end

      def no_merges
        config.include_merges
      end

      def bugs
        config.bugs
      end

      def features
        config.features
      end

      def misc
        config.misc
      end

      def regex_flag
        config.regex_type
      end

      def case_flag
        config.grep_insensitive?
      end

      def format
        config.log_format
      end

      def notes_already_created
        File.exist? config.output_file
      end
    end
  end
end
