# frozen_string_literal: true
module Release
  module Notes
    class FileWriter
      attr_accessor :file_name

      def initialize(file_name)
        @file_name = file_name
      end

      def digest(date = nil, title = nil, log_messages = nil)
        open(file_name, 'a') do |fi|
          fi << "## #{date}\n\n" if date
          fi << "#{title}\n\n" if title
          fi << "#{log_messages}\n" if log_messages
        end
      end
    end
  end
end
