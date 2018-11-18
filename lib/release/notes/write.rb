# frozen_string_literal: true

module Release
  module Notes
    class Write
      include Link
      include PrettyPrint
      include WithConfiguration

      attr_accessor :config

      delegate :output_file, :temp_file, :link_commits?, :all_labels,
               :prettify_messages?, :release_notes_exist?, to: :config

      def initialize(config)
        @config = config
        # create a new temp file regardless if it exists
        new_temp_file_template
      end

      def digest(date: nil, title: nil, log_message: nil)
        @date = date
        @title = title
        @log_message = log_message

        generate_file
      end

      # append old file to new temp file
      # overwrite output file with tmp file
      def write_new_file
        copy_over_notes if release_notes_exist?

        FileUtils.cp(temp_file, output_file)
        FileUtils.rm temp_file
      end

      # :nocov:
      private

      # @api private
      def generate_file
        File.open(temp_file, "a") do |fi|
          fi << date_present if date_present
          fi << date_and_title_present if date_and_title_present
          break unless @log_message
          fi << "#{remove_tags}\n"
        end
      end

      # @api private
      def date_present
        "\n## #{@date}\n" if @date
      end

      # @api private
      def date_and_title_present
        "#{@title}\n\n" if @title && @date
      end

      # @api private
      def remove_tags
        with_config(config: config) { prettify(line: link_messages) } if prettify_messages?
      end

      # @api private
      def link_messages
        link_message @log_message
      end

      # @api private
      def copy_over_notes
        File.open(temp_file, "a") do |f|
          f << "\n"
          IO.readlines(output_file)[2..-1].each { |line| f << line }
        end
      end

      # @api private
      def link_message(log_message)
        return log_message unless link_commits?

        with_config(config: config) do
          link_lines(lines: log_message)
        end
      end

      # @api private
      def new_temp_file_template
        File.new(temp_file, "w")
        File.open(temp_file, "a") do |fi|
          fi << "# Release Notes\n"
        end
      end
      # :nocov:
    end
  end
end
