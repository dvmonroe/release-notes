# frozen_string_literal: true

module Release
  module Notes
    class DateFormat
      attr_reader :config, :time_now
      delegate :timezone, to: :config

      def initialize(config)
        @config               = config
        Time.zone             = timezone

        @time_now             = Time.zone.now
      end

      def date_humanized(date: nil)
        date = date.present? ? Time.zone.parse(date) : time_now
        date.strftime("%B %d, %Y %r %Z")
      end
    end
  end
end
