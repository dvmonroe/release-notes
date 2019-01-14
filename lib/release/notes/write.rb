# frozen_string_literal: true

module Release
  module Notes
    class Write
      include Link
      include Configurable

      def initialize
        # create a new temp file regardless if it exists
        new_temp_file_template
      end

      # write strings to tempfile
      def digest(str)
        File.open(config_temp_file, "a") { |fi| fi << str }
      end

      # formats titles to be added to the new file
      # removes tags from title if configured
      def digest_title(title: nil, log_message: nil)
        @title = title
        @log_message = log_message

        titles = title_present + format_line
        digest(titles)
      end

      # formats the headers to be added to the new file
      def digest_header(header)
        @header = header
        digest(header_present)
      end

      # append old file to new temp file
      # overwrite output file with tmp file
      def write_new_file
        copy_over_notes if config_release_notes_exist? && !config_force_rewrite

        FileUtils.cp(config_temp_file, config_output_file)
        FileUtils.rm config_temp_file
      end

      private

      # @api private
      def header_present
        "#{NEWLINE}## #{@header}#{NEWLINE}"
      end

      # @api private
      def title_present
        "#{NEWLINE}#{@title}#{NEWLINE}#{NEWLINE}"
      end

      # @api private
      def format_line
        return "#{prettify_linked_messages}#{NEWLINE}" if config_prettify_messages?

        link_messages
      end

      # @api private
      def link_messages
        link_message @log_message
      end

      # @api private
      def prettify_linked_messages
        Prettify.new(line: link_messages).perform
      end

      # @api private
      def copy_over_notes
        File.open(config_temp_file, "a") do |f|
          f << NEWLINE
          IO.readlines(config_output_file)[2..-1].each { |line| f << line }
        end
      end

      # @api private
      def link_message(log_message)
        return log_message unless config_link_commits?

        link_lines(lines: log_message)
      end

      # @api private
      def new_temp_file_template
        File.open(config_temp_file, "w") do |fi|
          fi << "# Release Notes#{NEWLINE}"
        end
      end
    end
  end
end
