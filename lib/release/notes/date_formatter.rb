# frozen_string_literal: true

module Release
  module Notes
    class DateFormatter
      include Configurable
      attr_reader :date
      HUMANIZED = "%B %d, %Y %r %Z"

      #
      # Format the date
      #
      # @param [Date] date - parse date or return the current date/time
      #
      def initialize(date = nil)
        Time.zone = config_timezone
        @date = date.present? ? Time.zone.parse(date) : Time.zone.now
      end

      #
      # Format date
      #
      # @return [String] Month Day, Year, Time AM/PM Time Zone
      # ex: "January 17, 2019 10:22:53 PM EST"
      #
      def humanize
        date.strftime(HUMANIZED)
      end
    end
  end
end
