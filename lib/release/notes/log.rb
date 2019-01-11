# frozen_string_literal: true

module Release
  module Notes
    class Log
      include System
      include Configurable
      delegate :digest_header, :digest_title, to: :writer

      def initialize
        @_commits = []
      end

      def perform
        if config_release_notes_exist? && !config_force_rewrite
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
        [config_features, config_bugs, config_misc].each_with_index do |regex, i|
          log = system_log(tag_from: tag_from, tag_to: tag_to, label: regex, log_all: config_log_all)
          log_grouped_commits(title: titles[i], log: log)
        end

        return unless config_log_all

        log = system_log(tag_from: tag_from, tag_to: tag_to)
        log_grouped_commits(title: config_log_all_title, log: log)
      end

      # @api private
      def formatted_date(date = nil)
        DateFormatter.new(date).humanize
      end

      # @api private
      def find_last_tag_and_log
        last_tag = system_last_tag.strip
        # return false unless system_log(tag_from: last_tag, label: all_labels).present?
        if system_log(tag_from: last_tag, label: config_all_labels).blank?
          log_last
          return
        end
        # output the date right now
        header_content date: formatted_date, tag: tag_to
        copy_single_tag_of_activity(tag_from: last_tag)
      end

      # @api private
      def find_all_tags_and_log_all
        git_all_tags.each_with_index do |ta, i|
          header_content(
            date: formatted_date(System.tag_date(tag: ta)),
            tag: ta,
          )

          copy_single_tag_of_activity(
            tag_from: previous_tag(i).strip,
            tag_to: ta,
          )
        end
      end

      # @api private
      def log_last
        header_content date: formatted_date, tag: git_all_tags[0]
        copy_single_tag_of_activity(tag_from: git_all_tags[1], tag_to: git_all_tags[0])
      end

      # @api private
      def git_all_tags
        @git_all_tags ||= System.all_tags.split("\n")
      end

      # @api private
      def header_content(**date_and_tag)
        digest_header(date_and_tag[config_header_title_type.to_sym])
      end

      # @api private
      def log_grouped_commits(log:, title:)
        return unless log.present?

        log_messages = log.split("\n").map { |x| x.split(/(?=-)/) }
        commit_hashes = log_messages.flat_map { |msg| msg[0].strip }

        trimmed_commit_hashes = trim_commit_hashes(commit_hashes)

        digest_unique_messages(log_messages, trimmed_commit_hashes, title) if trimmed_commit_hashes.present?
      end

      # @api private
      def digest_unique_messages(log_messages, commit_hashes, title)
        messages = log_messages.map do |msg|
          msg[1..-1].join if commit_hashes.include?(msg[0].strip)
        end.compact

        @_commits += commit_hashes

        digest_title(title: title, log_message: "#{messages.join("\n")}\n")
      end

      # @api private
      def trim_commit_hashes(commit_hashes)
        commit_hashes.dup.each do |commit|
          commit_hashes.delete commit if config_single_label && @_commits.include?(commit)
        end
        commit_hashes
      end

      # @api private
      def previous_tag(index)
        git_all_tags[index + 1].present? ? git_all_tags[index + 1] : System.first_commit
      end

      # @api private
      def titles
        [config_feature_title, config_bug_title, config_misc_title]
      end

      # @api private
      def writer
        @writer ||= Release::Notes::Write.new
      end
    end
  end
end
