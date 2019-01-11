# frozen_string_literal: true

module Release
  module Notes
    class Commits
      include Configurable
      REGEX_DELIMETER = /(?=-)/

      attr_reader :title, :value
      delegate :digest_title, prefix: :writer, to: :@writer

      def initialize(title:, value:, writer:, tagger:)
        @title = title
        @value = value
        @writer = writer

        @tagger = tagger
      end

      def perform
        choose_messages_by_hash.tap do |obj|
          next if obj.empty?

          @tagger._hashes += obj.keys
          output_unique_messages(obj.values)
        end

        self
      end

      private

      # @api private
      def choose_messages_by_hash
        split_commits.tap do |obj|
          remove_duplicate_hashes(obj)
        end
      end

      # @api private
      def create_commits_hash(arr, hsh)
        hsh[arr[0].strip] = arr[1..-1].join
      end

      # @api private
      def duplicate_commit?(key)
        config_single_label && @tagger._hashes.include?(key)
      end

      # @api private
      def join_messages(arr)
        "#{arr.join(NEWLINE)}#{NEWLINE}"
      end

      # @api private
      def output_unique_messages(messages)
        writer_digest_title(title: title, log_message: join_messages(messages))
      end

      # @api private
      def remove_duplicate_hashes(obj)
        obj.keys.each { |key| obj.delete(key) if duplicate_commit?(key) }
      end

      # @api private
      def split_commits
        split_values do |arr, obj|
          arr.split(REGEX_DELIMETER).tap do |split_arr|
            create_commits_hash(split_arr, obj)
          end
        end
      end

      # @api private
      def split_values(&_block)
        value.split(NEWLINE).each_with_object({}) do |arr, obj|
          yield arr, obj
        end
      end
    end
  end
end
