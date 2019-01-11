# frozen_string_literal: true

module Release
  module Notes
    class System
      include Configurable
      attr_reader :opts

      def initialize(**opts)
        @opts = opts

        return unless opts.delete(:log_all) == true

        opts[:label] = config_all_labels
        opts[:invert_grep] = " --invert-grep"
      end

      def log
        `#{Git.log(opts)}`
      end

      class << self
        def first_commit
          `#{Git.first_commit}`
        end

        def all_tags
          `#{Git.read_all_tags}`
        end

        def last_tag
          `#{Git.last_tag}`
        end

        def tag_date(tag: nil)
          `#{Git.tag_date(tag || last_tag)}`
        end
      end
    end
  end
end
