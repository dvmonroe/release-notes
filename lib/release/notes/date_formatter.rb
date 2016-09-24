# frozen_string_literal: true
module Release
  module Notes
    class DateFormatter
      attr_reader :config, :time_now, :date_since, :date_until,
                  :date_until_midnight, :date_since_midnight, :start_date

      delegate :timezone, :before_midnight, :midnight, to: :config

      def initialize(config, start_date)
        @config = config
        @start_date = start_date
        Time.zone             = timezone

        @time_now             = Time.zone.now
        @date_since           = format_date_since
        @date_until           = format_date_until
        @date_until_midnight  = format_date_until(before_midnight)
        @date_since_midnight  = format_date_since(midnight)
      end

      protected

      def format_date_since(time = nil)
        formated Time.zone.parse(start_date), time
      end

      def format_date_until(time = nil)
        formated time_now, time
      end

      private

      def formated(date, time)
        hour_minutes = time.present? ? time : '%R'
        date.strftime("%F #{hour_minutes} %z")
      end
    end
  end
end
