# frozen_string_literal: true
module Release
  module Notes
    class FileWriter
      attr_accessor :config

      delegate :output_file, to: :config

      def initialize(config)
        @config = config
      end

      def digest(date = nil, title = nil, log_messages = nil)
        File.open(output_file, 'w') do |fi|
          fi << "## #{date}\n\n" if date
          fi << "#{title}\n\n" if title
          fi << "#{log_messages}\n" if log_messages
        end
      end
    end
  end
end
