# frozen_string_literal: true

module Release
  module Notes
    class Log
      include System

      attr_reader :writer, :date_formatter, :log_messages
      attr_reader :all_tags

      delegate :force_rewrite, :all_labels, :log_all, :header_title,
               :header_title_type, :features, :bugs, :misc, :feature_title,
               :bug_title, :misc_title, :log_all_title,
               :release_notes_exist?, to: :"Release::Notes.configuration"

      delegate :date_humanized, :format_tag_date, to: :date_formatter
      delegate :digest_header, :digest_title, to: :writer

      def initialize
        @writer = Release::Notes::Write.new
        @date_formatter = Release::Notes::DateFormat.new
        @log_messages = []
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

      def git_all_tags
        @git_all_tags ||= System.all_tags.split("\n")
        # return Error.new(msg: :missing_tags) unless all_tags.present?
      end

      # @api private
      def copy_single_tag_of_activity(tag_from:, tag_to: "HEAD")
        [features, bugs, misc].each_with_index do |regex, i|
          log = system_log(
            tag_from: tag_from,
            tag_to: tag_to,
            label: regex,
            log_all: false,
          )
          log_messages << [titles[i], log.split("\n")] if log.present?
        end

        send_to_writer

        return unless log_all

        log = system_log(
          tag_from: tag_from,
          tag_to: tag_to,
          log_all: true,
        )
        digest_title(title: log_all_title, log_message: log) if log.present?
      end

      def send_to_writer
        logger = Logger.new(STDOUT)
        logger.debug(log_messages)
        log_message.each do |title, messages|
          digest_title(title: titles[i], log_message: log) if log.present?
        end
      end

      # @api private
      def find_last_tag_and_log
        last_tag = system_last_tag.delete!("\n")
        return false unless system_log(tag_from: last_tag, label: all_labels).present?

        # output the date right now
        header_content date: date_humanized, tag: tag_to
        copy_single_tag_of_activity(tag_from: last_tag)
      end

      # @api private
      def find_all_tags_and_log_all
        git_all_tags.each_with_index do |ta, i|
          previous_tag = git_all_tags[i + 1]
          next unless previous_tag.present? &&
                      system_log(tag_from: previous_tag, tag_to: ta, label: all_labels).present?

          header_content date: date_humanized(date: System.tag_date(tag: ta)), tag: ta
          copy_single_tag_of_activity(tag_from: previous_tag, tag_to: ta)
        end
      end

      # @api private
      def header_content(**date_and_tag)
        digest_header(date_and_tag[header_title_type.to_sym])
      end

      # @api private
      def titles
        [feature_title, bug_title, misc_title]
      end
      # :nocov:
    end
  end
end
