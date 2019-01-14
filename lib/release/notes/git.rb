# frozen_string_literal: true

module Release
  module Notes
    class Git
      class << self
        include Configurable
        DEFAULT_TAG = "HEAD"

        def log(**opts)
          "git log '#{opts[:tag_from]}'..'#{opts[:tag_to]}'" \
            " --grep='#{opts[:label]}#{opts[:invert_grep]}'" \
            " #{config_regex_type} #{config_grep_insensitive?}" \
            " #{config_include_merges?} --format='%h #{log_format}'"
        end

        def first_commit
          "git rev-list --max-parents=0 #{DEFAULT_TAG}"
        end

        def last_tag
          "git describe --abbrev=0 --tags"
        end

        def tag_date(tag)
          "git log -1 --format=%ai #{tag}"
        end

        def read_all_tags
          "git for-each-ref --sort=taggerdate --format='%(tag)' refs/tags"
        end

        private

        def log_format
          "- %s"
        end
      end
    end
  end
end
