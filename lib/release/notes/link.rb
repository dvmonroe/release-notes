# frozen_string_literal: true

module Release
  module Notes
    module Link
      extend ActiveSupport::Concern

      included do
        include Configurable

        def link_lines(lines:)
          @new_lines = ""
          split_lines(lines)
          @new_lines
        end

        private

        # @api private
        def split_lines(lines)
          lines.split(NEWLINE).each do |line|
            unless config_link_to_labels&.any? { |la| line.include? la }
              @new_lines += "#{line}#{NEWLINE}"
              next
            end
            split_words(line)
          end
        end

        # @api private
        def split_words(line)
          config_link_to_labels.each_with_index do |label, i|
            next unless line.include? label

            replace_lines(line, label, i)
          end
        end

        # @api private
        def replace_lines(line, label, index)
          replace_words(line.split(/\s/))
          @new_lines += "#{replace(line, @word, label, index)}#{NEWLINE}" if @word
        end

        # @api private
        def replace_words(words)
          words.each do |word|
            next unless (word =~ /^#.*/)&.zero?

            @word = word
          end
        end

        # @api private
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
