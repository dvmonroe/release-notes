# frozen_string_literal: true

module Release
  module Notes
    module System
      module_function

      extend ActiveSupport::Concern
      include Git

      included do
        def system_log(**opts)
          if opts[:log_all] == true
            `#{invert_log(opts)}`
          else
            `#{log(opts)}`
          end
        end
      end

      def all_tags
        `#{Git.read_all_tags}`
      end

      def system_last_tag
        `#{Git.last_tag}`
      end

      def tag_date(tag: nil)
        tag ||= system_last_tag
        `#{Git.tag_date(tag)}`
      end
    end
  end
end
