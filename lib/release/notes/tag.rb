# frozen_string_literal: true

module Release
  module Notes
    class Tag
      include Configurable
      attr_accessor :_hashes
      attr_reader :tag, :previous_tag

      delegate :digest_header, prefix: :writer, to: :@writer

      def initialize(tag:, writer:, previous_tag:)
        @tag = tag
        @writer = writer
        @previous_tag = previous_tag

        @_commits = {}
        @_hashes = []
      end

      def perform
        store_commits

        if commits_available?
          writer_digest_header(header_title)
          log_commits
        end

        self
      end

      private

      # @api private
      def commits_available?
        @_commits.present?
      end

      # @api private
      def formatted_date(date = nil)
        DateFormatter.new(date).humanize
      end

      # @api private
      def header_title
        config_header_title.yield_self { |t| title(t) }
      end

      def log_commits
        @_commits.each do |key, val|
          Commits.new(title: titles[key], value: val, writer: @writer, tagger: self).perform
        end
      end

      # @api private
      def tag_date
        System.tag_date(tag: tag)
      end

      # @api private
      def store_commits
        all_labels.each_with_index do |lab, i|
          system_log(label: lab).tap { |str| @_commits[i] = str if str.present? }
        end

        @_commits[all_labels.size] = system_log(log_all: true) if config_log_all
      end

      # @api private
      def system_log(**opts)
        System.new({ tag_from: previous_tag, tag_to: tag }.merge(opts)).log
      end

      # @api private
      def all_labels
        [config_features, config_bugs, config_misc]
      end

      # @api private
      def titles
        [config_feature_title, config_bug_title,
         config_misc_title, config_log_all_title]
      end

      # @api private
      def title(title)
        title == "tag" ? tag : formatted_date(tag_date)
      end
    end
  end
end
