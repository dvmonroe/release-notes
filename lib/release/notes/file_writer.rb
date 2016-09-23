# frozen_string_literal: true
module Release
  module Notes
    class FileWriter
      attr_accessor :output_file

      def initialize(file_name)
        @output_file = file_name
      end

      # create a new file and append the old
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
