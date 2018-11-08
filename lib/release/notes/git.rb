# frozen_string_literal: true

module Release
  module Notes
    module Git
      module_function

      extend ActiveSupport::Concern

      included do
        delegate :log_format, :grep_insensitive?, :regex_type, :include_merges?, to: :config

        def log(**opts)
          "git log '#{opts[:tag_from]}'..'#{opts[:tag_to]}' --grep='#{opts[:label]}'" \
            " #{regex_type} #{grep_insensitive?}" \
            " #{include_merges?} --format='#{log_format}'"
        end
      end

      def last_tag
        "git describe --abbrev=0 --tags"
      end

      def tag_date(tag)
        "git log -1 --format=%ai #{tag}"
      end

      def read_all_tags
        "git tags | sort -u -r"
      end
    end
  end
end
