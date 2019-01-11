# frozen_string_literal: true

module Release
  module Notes
    module System
      module_function

      extend ActiveSupport::Concern

      delegate :all_labels, to: :"Release::Notes.configuration"

      included do
        def system_log(**opts)
          if opts.delete(:log_all) == true
            opts[:label] = all_labels
            opts[:invert_grep] = " --invert-grep"
          end

          `#{Git.log(opts)}`
        end
      end

      def first_commit
        `#{Git.first_commit}`
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
