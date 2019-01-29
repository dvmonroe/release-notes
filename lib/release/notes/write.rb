# frozen_string_literal: true

module Release
  module Notes
    class Write
      include Link
      include Configurable

      #
      # Release::Notes::Write initializer
      #
      # @return none
      #
      def initialize
        new_temp_file_template
      end

      #
      # Write strings to tempfile
      #
      # @param [String] str - string to add to the temp file
      #
      def digest(str)
        File.open(config_temp_file, "a") { |fi| fi << str }
      end

      # Formats titles to be added to the new file and removes tags from title if configured
      #
      # @param [String] title - string representing a label title
      # @param [String] log_message - string containing log messages that fall under the title
      #
      # @return [String] formatted label title and log messages that fall under it.
      #
      def digest_title(title: nil, log_message: nil)
        @title = title
        @log_message = log_message

        titles = title_present + format_line
        digest(titles)
      end

      #
      # Adds formatted header to changelog
      #
      # @param [String] header - unformatted header that needs to be added to changelog
      #
      def digest_header(header)
        @header = header
        digest(header_present)
      end

      #
      # append old file to new temp file
      # overwrite output file with tmp file
      #
      # @return none
      #
      def write_new_file
        copy_over_notes if config_release_notes_exist? && !config_force_rewrite?

        FileUtils.cp(config_temp_file, config_output_file)
        FileUtils.rm config_temp_file
      end

      private

      #
      # Formats the header
      #
      # @return [String] formatted header to be added to changelog
      #
      def header_present
        "#{NEWLINE}## #{@header}#{NEWLINE}"
      end

      #
      # Formats the title
      #
      # @return [String] formatted title to be added to changelog
      #
      def title_present
        "#{NEWLINE}#{@title}#{NEWLINE}#{NEWLINE}"
      end

      #
      # If prettify_messages is true, remove the label keyword from log message
      # else, just return the log message
      #
      # @return [String] log message to be added to changelog
      #
      def format_line
        return "#{prettify_linked_messages}#{NEWLINE}" if config_prettify_messages?

        link_messages
      end

      #
      # Calls link_message method with a log message
      #
      # @return [String] log message to be added to the changelog
      #
      def link_messages
        link_message @log_message
      end

      #
      # Prettifies linked log messages
      #
      # @return [String] formatted log message
      #
      def prettify_linked_messages
        Prettify.new(line: link_messages).perform
      end

      #
      # Appends previous changelog to a temporary file
      #
      # @return none
      #
      def copy_over_notes
        File.open(config_temp_file, "a") do |f|
          f << NEWLINE
          IO.readlines(config_output_file)[2..-1].each { |line| f << line }
        end
      end

      #
      # Returns the log message if message linking is not configured
      # else, return the linked log_message
      #
      # @return [String] original or updated log essage
      #
      def link_message(log_message)
        return log_message unless config_link_commits?

        link_lines(lines: log_message)
      end

      #
      # Open temp file and output release notes header
      #
      # @return none
      #
      def new_temp_file_template
        File.open(config_temp_file, "w") do |fi|
          fi << "# Release Notes#{NEWLINE}"
        end
      end
    end
  end
end
