# frozen_string_literal: true

module Release
  module Notes
    class System
      include Configurable
      attr_reader :opts

      #
      # Release::Notes::System initializer
      #
      # @param **opts
      #
      # @return none
      #
      def initialize(**opts)
        @opts = opts

        return unless opts.delete(:log_all) == true

        opts[:label] = config_all_labels
        opts[:invert_grep] = " --invert-grep"
      end

      #
      # Call Git.log method with configurable options
      #
      # @return [String] shell output of running Git.log
      #
      def log
        `#{Git.log(opts)}`
      end

      class << self
        #
        # Call Git.first_commit method
        #
        # @return [String] shell output of running Git.first_commit
        #
        def first_commit
          `#{Git.first_commit}`
        end

        #
        # Call Git.read_all_tags method
        #
        # @return [String] shell output of running Git.read_all_tags
        #
        def all_tags
          `#{Git.read_all_tags}`
        end

        #
        # Call Git.last_tag method
        #
        # @return [String] shell output of running Git.last_tag
        #
        def last_tag
          `#{Git.last_tag}`
        end

        #
        # Call Git.tag_date method
        #
        # @param [String] tag - a tag that you want to get the date created for
        #
        # @return [String] shell output of running Git.tag_date
        #
        def tag_date(tag: nil)
          `#{Git.tag_date(tag || last_tag)}`
        end
      end
    end
  end
end
