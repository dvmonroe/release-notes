# frozen_string_literal: true

module Release
  module Notes
    class Log
      include System
      delegate :force_rewrite, :all_labels, :log_all, :header_title,
               :header_title_type, :features, :bugs, :misc, :feature_title,
               :bug_title, :misc_title, :log_all_title, :single_label,
               :release_notes_exist?, to: :"Release::Notes.configuration"

      delegate :date_humanized, :format_tag_date, to: :date_formatter
      delegate :digest_header, :digest_title, to: :writer

      def initialize
        @_commits = []
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

      private

      # @api private
      def copy_single_tag_of_activity(tag_from:, tag_to: "HEAD")
        [features, bugs, misc].each_with_index do |regex, i|
          log_single_commit(regex: regex, title: titles[i], tag_from: tag_from, tag_to: tag_to)
        end

        return unless log_all

        log_single_commit(title: log_all_title, tag_from: tag_from, tag_to: tag_to)
      end

      # @api private
      def date_formatter
        @date_formatter ||= Release::Notes::DateFormat.new
      end

      # @api private
      def find_last_tag_and_log
        last_tag = system_last_tag.strip
        return false unless system_log(tag_from: last_tag, label: all_labels).present?

        # output the date right now
        header_content date: date_humanized, tag: tag_to
        copy_single_tag_of_activity(tag_from: last_tag)
      end

      # @api private
      def find_all_tags_and_log_all
        git_all_tags.each_with_index do |ta, i|
          header_content(
            date: date_humanized(date: System.tag_date(tag: ta)),
            tag: ta,
          )

          copy_single_tag_of_activity(
            tag_from: previous_tag(i).strip,
            tag_to: ta,
          )
        end
      end

      # @api private
      def git_all_tags
        @git_all_tags ||= System.all_tags.split("\n")
      end

      # @api private
      def header_content(**date_and_tag)
        digest_header(date_and_tag[header_title_type.to_sym])
      end

      # @api private
      def log_single_commit(tag_from:, tag_to:, title:, regex: nil, log_all: false)
        log = system_log(
          tag_from: tag_from,
          tag_to: tag_to,
          label: regex,
          log_all: log_all,
        ).split(/(?=-)/)

        commit_hash = log[0]

        return unless log.present?
        return if single_label && @_commits.include?(commit_hash)

        @_commits << commit_hash
        digest_title(title: title, log_message: log[1])
      end

      def previous_tag(index)
        git_all_tags[index + 1].present? ? git_all_tags[index + 1] : System.first_commit
      end

      # @api private
      def titles
        [feature_title, bug_title, misc_title]
      end

      # @api private
      def writer
        @writer ||= Release::Notes::Write.new
      end
    end
  end
end
