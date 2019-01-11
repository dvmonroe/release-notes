# frozen_string_literal: true

module Release
  module Notes
    class DateFormatter
      include Configurable
      attr_reader :date

      def initialize(date = nil)
        Time.zone = config_timezone

        @date = date.present? ? Time.zone.parse(date) : Time.zone.now
      end

      def humanize
        date.strftime("%B %d, %Y %r %Z")
      end
    end
  end
end
