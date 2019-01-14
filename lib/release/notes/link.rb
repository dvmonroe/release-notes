# frozen_string_literal: true

module Release
  module Notes
    module Link
      extend ActiveSupport::Concern

      included do
        include Configurable

        #
        # Link log messages
        #
        # @param [String] lines - log messages for a git tag
        #
        # @return [String] log messages that can be linked
        #
        def link_lines(lines:)
          @new_lines = ""
          split_lines(lines)
          @new_lines
        end

        private

        #
        # Format lines or add link if log message should be linked
        #
        # @param [String] lines - log messages for a given git commit
        #
        # @return [Array] label log messages should be linked to
        #
        def split_lines(lines)
          lines.split(NEWLINE).each do |line|
            unless config_link_to_labels&.any? { |la| line.include? la }
              @new_lines += "#{line}#{NEWLINE}"
              next
            end
            split_words(line)
          end
        end

        #
        # Determine if log message has a pre-determined label
        #
        # @param [String] line - a line from the log messages
        #
        # @return none
        #
        def split_words(line)
          config_link_to_labels.each_with_index do |label, i|
            next unless line.include? label

            replace_lines(line, label, i)
          end
        end

        #
        # Replace a word in the changelog
        #
        # @param [String line - a line from the log messages
        # @param [String] label - a specified label
        # @param [Integer] index - index of log message
        #
        # @return none
        #
        def replace_lines(line, label, index)
          replace_words(line.split(/\s/))
          @new_lines += "#{replace(line, @word, label, index)}#{NEWLINE}" if @word
        end

        #
        # Replace words if log message
        #
        # @param [Array] words - split git log message
        #
        # @return [String] word to replace in the log message
        #
        def replace_words(words)
          words.each do |word|
            next unless (word =~ /^#.*/)&.zero?

            @word = word
          end
        end

        #
        # Replace log messages with linked messages
        #
        # @param [String] line - log message to replace
        # @param [String] issue_number - word to replace
        # @param [String] label - label to replace with
        # @param [Integer] index - index of the linked site
        #
        # @return [String] formatted linked line
        #
        def replace(line, issue_number, label, index)
          identifier = "#{label.split(/\s/)[0]} #{issue_number}"
          humanized = "#{config_link_to_humanize[index]} #{issue_number}"
          linked = "[#{humanized}](#{config_link_to_sites[index]}\/#{issue_number.tr('^0-9', '')})"

          line.gsub! identifier, linked
          line
        end
      end
    end
  end
end
