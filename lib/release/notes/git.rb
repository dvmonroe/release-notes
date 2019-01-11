# frozen_string_literal: true

module Release
  module Notes
    class Git
      class << self
        delegate :grep_insensitive?, :regex_type, :include_merges?, to: :"Release::Notes.configuration"

        def log(**opts)
          "git log '#{opts[:tag_from]}'..'#{opts[:tag_to]}'" \
            " --grep='#{opts[:label]}#{opts[:invert_grep]}'" \
            " #{regex_type} #{grep_insensitive?}" \
            " #{include_merges?} --format='%h #{log_format}'"
        end

        def first_commit
          "git rev-list --max-parents=0 HEAD"
        end

        def last_tag
          "git describe --abbrev=0 --tags"
        end

        def tag_date(tag)
          "git log -1 --format=%ai #{tag}"
        end

        def read_all_tags
          "git tag | sort -u -r"
        end

        private

        def log_format
          "- %s"
        end
      end
    end
  end
end
