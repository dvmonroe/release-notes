# frozen_string_literal: true
module Release
  module Notes
    class Prettify
      attr_reader :config
      delegate :bug_labels, :feature_labels, :misc_labels, to: :config

      def initialize(config)
        @config = config
      end

      def perform(line)
        labels.each do |label|
          next unless line.include? label
          line.gsub! label, ''
        end
        line
      end

      private

      # @api private
      def labels
        bug_labels + feature_labels + misc_labels
      end
    end
  end
end
