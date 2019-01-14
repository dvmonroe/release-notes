# frozen_string_literal: true

module Release
  module Notes
    class Commits
      include Configurable
      REGEX_DELIMETER = /(?=-)/

      attr_reader :title, :value
      delegate :digest_title, prefix: :writer, to: :@writer

      #
      # Release::Notes::Commits initializer method
      #
      # @param [String] title - a label (**Implemented enhancements.**)
      # @param [String] value - all commits and commit subjects (sha - message\n)
      # @param [Release::Notes::Writer] writer - Writer obeject containing the message header (v2.0.0)
      #
      def initialize(title:, value:, writer:, tagger:)
        @title = title
        @value = value
        @writer = writer

        @tagger = tagger
      end

      #
      # Perform method
      #
      # @return [File] File with array of git sha's
      #
      def perform
        choose_messages_by_hash.tap do |obj|
          next if obj.empty?

          @tagger._hashes += obj.keys
          output_unique_messages(obj.values)
        end

        self
      end

      private

      #
      # Determine what messages will be added to final output
      #
      # @return [Array] non-duplicated log messages
      #
      def choose_messages_by_hash
        split_commits.tap do |obj|
          remove_duplicate_hashes(obj)
        end
      end

      #
      # Create the commits hash
      #
      # @param [Array] arr - Array where [0] is a commit hash and [1] is the first formatted commit message for...
      # @param [Hash] hsh - Hash of formatted commit messages to be injected per sha
      #
      # @return [String] Commit message
      #
      def create_commits_hash(arr, hsh)
        hsh[arr[0].strip] = arr[1..-1].join
      end

      #
      # Determines whether key has already been added to the release_notes
      #
      # @param [String] key - commit sha
      #
      # @return [Boolean] Is this a duplicate commit message?
      #
      def duplicate_commit?(key)
        config_single_label && @tagger._hashes.include?(key)
      end

      #
      # Transforms an array of messages into a single
      #
      # @param [Array] arr - array formatted log messages
      #
      # @return [String] formatted log messages
      #
      def join_messages(arr)
        "#{arr.join(NEWLINE)}#{NEWLINE}"
      end

      #
      # Log messages without duplicates
      #
      # @param [Array] messages - Array of git commit subjects
      #
      # @return [String] - formatted messages
      #
      def output_unique_messages(messages)
        writer_digest_title(title: title, log_message: join_messages(messages))
      end

      #
      # Remove duplicate log messages
      #
      # @param [Hash] obj - Commit sha's and messages
      #
      # @return [Array] Array of unique git sha's
      #
      def remove_duplicate_hashes(obj)
        obj.keys.each { |key| obj.delete(key) if duplicate_commit?(key) }
      end

      #
      # Split commits by sha
      #
      # @return [Hash] Commit and message
      #
      def split_commits
        split_values do |arr, obj|
          arr.split(REGEX_DELIMETER).tap do |split_arr|
            create_commits_hash(split_arr, obj) # "- Add our own release notes"
          end
        end
      end

      #
      # Split messages by sha
      #
      # @param [Proc] &_block - optional block
      #
      # @return [Hash] commits and commit sha's
      #
      # NEWLINE = "\n"
      #
      def split_values(&_block)
        value.split(NEWLINE).each_with_object({}) do |arr, obj|
          yield arr, obj
        end
      end
    end
  end
end
