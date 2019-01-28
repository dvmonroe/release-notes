# frozen_string_literal: true

module Release
  module Notes
    class Log
      include Configurable

      #
      # Release::Notes::Log initializer
      #
      # @return none
      #
      def perform
        log_from_start? ? find_all_tags_and_log_all : find_last_tag_and_log

        writer.write_new_file
      end

      private

      #
      # Find the most recent git tag
      #
      # @return [Array] most recent git tag
      #
      def find_last_tag_and_log
        tag_logger(System.last_tag.strip, find_previous_tag(1))
      end

      #
      # Get all git tags and add to the changelog
      #
      # @return [Array] all the git tags
      #
      def find_all_tags_and_log_all
        git_all_tags.each_with_index do |ta, i|
          tag_logger(ta, find_previous_tag(i + 1))
        end
      end

      #
      # Check whether to start from the beginning of the git log
      #
      # @return [Boolean] append to changelog or start from beginning of git log
      #
      def log_from_start?
        !config_release_notes_exist? || config_force_rewrite
      end

      #
      # All tags in the git log
      #
      # @return [Array] all git tags
      #
      def git_all_tags
        @git_all_tags ||= System.all_tags.split(NEWLINE).reverse
      end

      #
      # Second to last tag in the git log
      #
      # @param [Integer] index - index of the git tags array
      #
      # @return [String] second most recent git tag
      #
      def find_previous_tag(idx)
        git_all_tags[idx].yield_self { |t| tag(t) }.strip
      end

      #
      # Get the next git tag or the first tag
      #
      # @param [String] git_tag - a git tag
      #
      # @return [String] most recent git tag or the first git tag
      #
      def tag(git_tag)
        git_tag.present? ? git_tag : System.first_commit
      end

      #
      # Create a Release::Notes::Tag object
      #
      # @param [String] tag - tag to
      # @param [String] previous_tag - tag from
      #
      # @return [Object] Release::Notes::Tag object
      #
      def tag_logger(tag, previous_tag)
        Tag.new(
          tag: tag,
          previous_tag: previous_tag,
          writer: writer,
        ).perform
      end

      #
      # Create write object containing the header, title, and log messages for a given tag
      #
      # @return [Object] Release::Notes::Write object
      #
      def writer
        @writer ||= Write.new
      end
    end
  end
end
