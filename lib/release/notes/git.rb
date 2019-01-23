# frozen_string_literal: true

module Release
  module Notes
    class Git
      class << self
        include Configurable
        DEFAULT_TAG = "HEAD"

        #
        # Returns a string matching the following format: "hash - message\n"
        # for all commits falling within the tag_from and tag_to threshold
        # taking account the relevant label, invert grep options, and log format
        #
        # @param **opts
        #
        # @return [String] git log entries between tag_from and tag_to that include the word(s) in label,
        # taking into account the invert grep and log_format flags specified.
        #
        def log(**opts)
          "git log '#{opts[:tag_from]}'..'#{opts[:tag_to]}'" \
            " --grep='#{opts[:label]}#{opts[:invert_grep]}'" \
            " #{config_regex_type} #{config_grep_insensitive?}" \
            " #{config_include_merges?} --format='%h #{log_format}'"
        end

        #
        # Returns the git hash of the first commit.
        #
        # @return [String] the first commit hash.
        #
        def first_commit
          "git rev-list --max-parents=0 #{DEFAULT_TAG}"
        end

        #
        # Returns the latest git tag.
        #
        # @return [String] the most recent tag.
        #
        def last_tag
          "git describe --abbrev=0 --tags"
        end

        #
        # Returns the date and time of the latest tag.
        #
        # @param [String] a git tag
        #
        # @return [String] the most recent tag date.
        #
        def tag_date(tag)
          "git log -1 --format=%ai #{tag}"
        end

        #
        # Returns an array of all tags in the git log
        #
        # @return [Array] all git tags
        #
        def read_all_tags
          "git for-each-ref --sort=taggerdate --format='%(tag)' refs/tags"
        end

        private

        #
        # Returns a string representing the git log format flag
        #
        # @return [String] git log format flag
        #
        def log_format
          "- %s"
        end
      end
    end
  end
end
