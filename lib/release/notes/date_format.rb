# frozen_string_literal: true

module Release
  module Notes
    class DateFormat
      attr_reader :time_now
      delegate :timezone, to: :"Release::Notes.configuration"

      def initialize
        Time.zone = timezone
      end

      def date_humanized(date: nil)
        date = date.present? ? Time.zone.parse(date) : Time.zone.now
        date.strftime("%B %d, %Y %r %Z")
      end
    end
  end
end
