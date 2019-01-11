# frozen_string_literal: true

module Release
  module Notes
    module PrettyPrint
      extend ActiveSupport::Concern

      included do
        include Configurable

        def prettify(line:)
          line.gsub(labels_regex, "").strip
        end
      end

      private

      # @api private
      def labels_regex
        Regexp.new config_all_labels, Regexp::IGNORECASE
      end
    end
  end
end
