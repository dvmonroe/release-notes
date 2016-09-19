# frozen_string_literal: true
module Release
  module Notes
    class Updater
      attr_reader   :config
      attr_accessor :git
      attr_accessor :writer

      def initialize
        @config = Release::Notes.configuration
        @git    = Git.new(config)
        @writer = FileWriter.new(output_file)
      end

      def run
        return loop_and_log if config.by_release?
        loop_sort_and_log
      end

      private

      def loop_sort_and_log
        logged_dates = git.sorted_log(all_labels)
        dates = logged_dates.split("\n")

        # return better error when commits have
        # been made since the last tagged release
        return false unless dates
        dates.each do |date|
          writer.digest date
          single_date_of_activity
        end
        true
      end

      def loop_and_log
        return unless git.log(all_labels)
        writer.digest until_when
        single_date_of_activity
        true
      end

      def single_date_of_activity
        array_of_labels.each_with_index do |regex, i|
          new_log = git.log(regex)
          writer.digest titles[i], new_log if new_log.present?
        end
      end

      def all_labels
        config.all_labels
      end

      def output_file
        config.notes_file
      end

      def array_of_labels
        [config.features,
         config.bugs,
         config.misc]
      end

      def titles
        [config.feature_title,
         config.bug_title,
         config.misc_title]
      end
    end
  end
end
