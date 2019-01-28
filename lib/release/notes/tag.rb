# frozen_string_literal: true

module Release
  module Notes
    class Tag
      include Configurable
      attr_accessor :_hashes
      attr_reader :tag, :previous_tag

      delegate :digest_header, prefix: :writer, to: :@writer

      # Release::Notes::Tag initializer
      #
      # @param [String] tag - a git tag (ex: v2.0.0)
      # @param [Release::Notes::Write] writer - an object containing a header, title, and associated log messages
      # @param [String] previous_tag - the previous git tag (ex: v1.3.0)
      def initialize(tag:, writer:, previous_tag:)
        @tag = tag
        @writer = writer
        @previous_tag = previous_tag

        @_commits = {}
        @_hashes = []
      end

      #
      # Adds log messages to @_commits variable, and if there are commits that need to be added to
      # changelog, add the header and associated log messages
      #
      # @return none
      #
      def perform
        store_commits # adds to @_commits

        if commits_available? # true
          writer_digest_header(header) # <File:./release-notes.tmp.md (closed)>
          log_commits # hash [0,1,2...], messages for sha
        end

        self
      end

      private

      #
      # Are there git sha's with commits?
      #
      # @return [Boolean] true: commits are present, false: there are no commits
      #
      def commits_available?
        @_commits.present?
      end

      #
      # Formats a supplied date
      #
      # @param [String] date - a date
      #
      # @return [String] formatted date
      #
      def formatted_date(date = nil)
        DateFormatter.new(date).humanize
      end

      #
      # Generate header title
      #
      # @return [String] the header to be added to changelog
      #
      def header
        config_header_title_type.yield_self { |t| title(t) } # config_header_title = "tag"
      end

      #
      # Creates new commit objects from the @_commits object
      #
      # @return [Hash] unique log messages per tag
      #
      def log_commits
        @_commits.each do |key, val|
          Commits.new(title: titles[key], value: val, writer: @writer, tagger: self).perform
        end
      end

      #
      # Transform tag into date
      #
      # @return [String] date the tag was created
      #
      def tag_date
        System.tag_date(tag: tag)
      end

      #
      # Adds log messages to @_commits
      #
      # @return none
      #
      def store_commits
        all_labels.each_with_index do |lab, i|
          system_log(label: lab).tap { |str| @_commits[i] = str if str.present? }
        end

        # if log_all = true
        @_commits[all_labels.size] = system_log(log_all: true) if config_log_all
      end

      #
      # Create new system object that contains log messages between tag_from and tag_to
      # with the relevant options
      #
      # @param [Hash] opts - options like the label to grep
      #
      # @return [String] log messages that meet the criteria
      #
      def system_log(**opts)
        System.new({ tag_from: previous_tag, tag_to: tag }.merge(opts)).log
      end

      #
      # Array of strings containing all labels
      #
      # @return [Array] array of all labels
      #
      def all_labels
        [config_features, config_bugs, config_misc]
      end

      #
      # Array of strings containing all titles
      #
      # @return [Array] array of all titles
      #
      def titles
        [config_feature_title, config_bug_title,
         config_misc_title, config_log_all_title]
      end

      #
      # Title or formatted tag date
      #
      # @param [String] title - should the title be the git tag? If yes, use the git
      # tag as the title, if not use the tag date
      #
      # @return [String] tag title or formatted tag date to be added to changelog
      #
      def title(title)
        title == "tag" ? tag : formatted_date(tag_date)
      end
    end
  end
end
