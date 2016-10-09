# frozen_string_literal: true
module Release
  module Notes
    class Prettify
      attr_reader :config

      def initialize(config)
        @config = config
      end

      def perform(msg)
        # TODO: remove label from msg
      end
    end
  end
end
