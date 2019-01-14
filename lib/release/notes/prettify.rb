# frozen_string_literal: true

module Release
  module Notes
    class Prettify
      include Configurable
      attr_reader :line

      def initialize(line:)
        @line = line
      end

      def perform
        line.gsub(labels_regex, "").strip
      end

      private

      # @api private
      def labels_regex
        Regexp.new config_all_labels, Regexp::IGNORECASE
      end
    end
  end
end
