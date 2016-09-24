# frozen_string_literal: true
module Release
  module Notes
    class Logger
      attr_reader :config, :writer, :dates

      delegate :by_release?, :all_labels, :features, :bugs, :misc,
               :feature_title, :bug_title, :misc_title,
               :release_notes_exist?, :first_commit_date, to: :config

      def initialize(config)
        @config = config
        @start_date = set_start_date_time

        @writer = Release::Notes::FileWriter.new(@config)
        @dates = Release::Notes::DateFormatter.new(@config, @start_date)
      end

      def copy_logs
        return loop_and_log if by_release?
        loop_sort_and_log
      end

      protected

      def loop_sort_and_log
        dates = system_sorted_log.split("\n")

        raise false unless dates
        dates.each do |date|
          writer.digest date
          copy_single_date_of_activity
        end
      end

      def loop_and_log
        raise false unless system_log(all_labels)
        writer.digest dates.time_now
        copy_single_date_of_activity
      end

      def set_start_date_time
        release_notes_exist? ? Release::Notes::System.tag_date : which_commit
      end

      def which_commit
        first_commit_date.present? ? first_commit_date : Release::Notes::System.first_commit
      end

      private

      def copy_single_date_of_activity
        [features, bugs, misc].each_with_index do |regex, i|
          writer.digest titles[i], new_log if system_log(regex).present?
        end
      end

      def system_log(reg)
        Release::Notes::System.log(config, dates, reg)
      end

      def system_sorted_log
        Release::Notes::System.sorted_log(config, dates, all_labels)
      end

      def titles
        [feature_title, bug_title, misc_title]
      end
    end
  end
end
