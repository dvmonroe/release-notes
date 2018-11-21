# frozen_string_literal: true

module Release
  module Notes
    class Log
      include System
      include WithConfiguration

      attr_reader :config, :writer, :date_formatter
      attr_reader :all_tags

      delegate :force_rewrite, :all_labels, :log_all, :features, :bugs, :misc, :feature_title,
               :bug_title, :misc_title, :log_all_title, :release_notes_exist?, to: :config
      delegate :date_humanized, :format_tag_date, to: :date_formatter
      delegate :digest_date, :digest_title, to: :writer

      def initialize(config)
        @config = config

        setup_writer
        setup_date_formatter
      end

      def perform
        if release_notes_exist? && !force_rewrite
          # Find the last tag and group all commits
          # under a date header at the time this is run
          find_last_tag_and_log
        else
          # Find all tags and get the logs between each tag
          # run this the first time if nothing exists
          find_all_tags_and_log_all
        end
        writer.write_new_file
      end

      # :nocov:
      private

      def all_tags # rubocop:disable Lint/DuplicateMethods
        @all_tags ||= System.all_tags.split("\n")
        # return Error.new(msg: :missing_tags) unless all_tags.present?
      end

      # @api private
      def copy_single_tag_of_activity(tag_from:, tag_to: nil)
        tag_to ||= "HEAD"
        [features, bugs, misc].each_with_index do |regex, i|
          log = system_call(tag_from: tag_from, tag_to: tag_to, label: regex, log_all: false)
          digest_title(title: titles[i], log_message: log) if log.present?
        end

        return unless log_all

        log = system_call(tag_from: tag_from, tag_to: tag_to, log_all: true)
        digest_title(title: log_all_title, log_message: log) if log.present?
      end

      # @api private
      def find_last_tag_and_log
        last_tag = system_last_tag.delete!("\n")
        return false unless system_call(tag_from: last_tag, label: all_labels).present?

        # output the date right now
        digest_date date: date_humanized
        copy_single_tag_of_activity(tag_from: last_tag)
      end

      # @api private
      def setup_writer
        @writer = Release::Notes::Write.new config
      end

      # @api private
      def setup_date_formatter
        @date_formatter = Release::Notes::DateFormat.new config
      end

      # @api private
      def find_all_tags_and_log_all
        all_tags.each_with_index do |ta, i|
          previous_tag = all_tags[i + 1]
          next unless previous_tag.present? &&
                      system_call(tag_from: previous_tag, tag_to: ta, label: all_labels).present?

          digest_date date: date_humanized(date: System.tag_date(tag: ta))
          copy_single_tag_of_activity(tag_from: previous_tag, tag_to: ta)
        end
      end

      # @api private
      def system_call(**opts)
        with_config(config: config) do
          system_log(opts)
        end
      end

      def titles
        [feature_title, bug_title, misc_title]
      end
      # :nocov:
    end
  end
end
