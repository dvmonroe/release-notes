# frozen_string_literal: true

module Release
  module Notes
    class DateFormat
      include Configurable

      def initialize
        Time.zone = config_timezone
      end

      def date_humanized(date: nil)
        date = date.present? ? Time.zone.parse(date) : Time.zone.now
        date.strftime("%B %d, %Y %r %Z")
      end
    end
  end
end
