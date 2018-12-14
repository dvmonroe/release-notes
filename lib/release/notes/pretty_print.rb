# frozen_string_literal: true

module Release
  module Notes
    module PrettyPrint
      extend ActiveSupport::Concern

      included do
        delegate :all_labels, to: :"Release::Notes.configuration"

        def prettify(line:)
          line.gsub(labels_regex, "").strip
        end
      end

      private

      # @api private
      def labels_regex
        Regexp.new all_labels, Regexp::IGNORECASE
      end
    end
  end
end
