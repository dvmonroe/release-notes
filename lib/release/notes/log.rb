# frozen_string_literal: true

module Release
  module Notes
    class Log
      include Configurable

      def perform
        if log_from_start?
          # Find all tags and get the logs between each tag
          # run this the first time if nothing exists
          find_all_tags_and_log_all
        else
          # Find the last tag and group all commits
          # under a date header at the time this is run
          find_last_tag_and_log
        end

        writer.write_new_file
      end

      private

      # @api private
      def find_last_tag_and_log
        tag_logger(System.last_tag.strip, previous_tag(0))
      end

      # @api private
      def find_all_tags_and_log_all
        git_all_tags.each_with_index do |ta, i|
          tag_logger(ta, previous_tag(i))
        end
      end

      # @api private
      def log_from_start?
        !config_release_notes_exist? || config_force_rewrite
      end

      # @api private
      def git_all_tags
        @git_all_tags ||= System.all_tags.split(NEWLINE).reverse
      end

      # @api private
      def previous_tag(index)
        git_all_tags[index + 1].yield_self { |t| tag(t) }.strip
      end

      # @api private
      def tag(git_tag)
        git_tag.present? ? git_tag : System.first_commit
      end

      # @api private
      def tag_logger(tag, previous_tag)
        Tag.new(tag: tag, previous_tag: previous_tag, writer: writer).perform
      end

      # @api private
      def writer
        @writer ||= Write.new
      end
    end
  end
end
