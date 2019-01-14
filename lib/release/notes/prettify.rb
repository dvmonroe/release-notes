# frozen_string_literal: true

module Release
  module Notes
    class Prettify
      include Configurable
      attr_reader :line

      #
      # Release::Notes::Prettify initializer
      #
      # @param [String] line - a line from the git log
      #
      def initialize(line:)
        @line = line
      end

      #
      # Perform method for Release::Notes::Prettify
      #
      # @return [String] log message
      #
      def perform
        line.gsub(labels_regex, "").strip
      end

      private

      #
      #  Holds the regular expression used to match a pattern against labels
      #
      # @return [Regexp] regex containing all labels
      #
      def labels_regex
        Regexp.new config_all_labels, Regexp::IGNORECASE
      end
    end
  end
end
