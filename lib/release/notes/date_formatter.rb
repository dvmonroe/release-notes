# frozen_string_literal: true

module Release
  module Notes
    class DateFormatter
      include Configurable
      attr_reader :date
      HUMANIZED = "%B %d, %Y %r %Z"

      def initialize(date = nil)
        Time.zone = config_timezone

        @date = date.present? ? Time.zone.parse(date) : Time.zone.now
      end

      def humanize
        date.strftime(HUMANIZED)
      end
    end
  end
end
