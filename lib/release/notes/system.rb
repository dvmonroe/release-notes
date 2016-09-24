# frozen_string_literal: true
module Release
  module Notes
    module System
      module_function

      def log(config, dates, label)
        `#{Release::Notes::Git.new(config, dates).log(label)}`
      end

      def sorted_log(config, dates, label)
        `#{Release::Notes::Git.new(config, dates).sorted_log(label)}`
      end

      def last_tag
        `#{Release::Notes::Git.last_tag}`
      end

      def tag_date
        `#{Release::Notes::Git.tag_date(last_tag)}`
      end

      def first_commit
        `#{Release::Notes::Git.first_commit}`
      end
    end
  end
end
