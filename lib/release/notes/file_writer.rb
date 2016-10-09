# frozen_string_literal: true
module Release
  module Notes
    class FileWriter
      attr_accessor :config, :temp_file, :linker, :prettify

      delegate :output_file, :temp_file, :link_commits?, :prettify_messages?, to: :config
      delegate :linkify, to: :linker

      def initialize(config)
        @config = config
        @linker = Release::Notes::Linker.new(@config)
        @prettify = Release::Notes::Prettify.new(@config)
        # create a new temp file regardless if it exists
        new_temp_file_template
      end

      def digest(date = nil, title = nil, log_message = nil)
        File.open(temp_file, 'a') do |fi|
          fi << "## #{date}\n\n" if date
          fi << "#{title}\n\n" if title

          if log_message
            # link messages if needed
            msg = link_commits? ? linkify(log_message) : log_message
            # remove tags if needed
            msg = prettify.perform(msg) if prettify_messages?
            fi << "#{msg}\n"
          end
        end
      end

      # append old file to new temp file
      # overwrite output file with tmp file
      def write_new_file
        copy_over_notes if File.exist? output_file
        FileUtils.cp(temp_file, output_file)
        FileUtils.rm temp_file
      end

      private

      def copy_over_notes
        File.open(temp_file, 'a') do |f|
          IO.readlines(output_file)[2..-1].each { |line| f << line }
        end
      end

      def new_temp_file_template
        File.new(temp_file, 'w')
        File.open(temp_file, 'a') do |fi|
          fi << "# Release Notes\n----------------------\n\n"
        end
      end
    end
  end
end
