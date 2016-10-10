# frozen_string_literal: true

module Release
  module Notes
    module WithConfiguration
      extend ActiveSupport::Concern

      included do
        attr_reader :config, :date_formatter

        def with_config(**opts, &_block)
          @confg = opts.fetch(:config, {})
          yield
        end
      end
    end
  end
end
