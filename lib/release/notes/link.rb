# frozen_string_literal: true

module Release
  module Notes
    module Link
      extend ActiveSupport::Concern

      included do
        delegate :link_to_labels, :link_to_sites, :link_to_humanize, to: :"Release::Notes.configuration"

        def link_lines(lines:)
          @new_lines = ""
          split_lines(lines)
          @new_lines
        end

        # :nocov:
        private

        # @api private
        def split_lines(lines)
          lines.split("\n").each do |line|
            unless link_to_labels&.any? { |la| line.include? la }
              @new_lines += "#{line}\n"
              next
            end
            split_words(line)
          end
        end

        # @api private
        def split_words(line)
          link_to_labels.each_with_index do |label, i|
            next unless line.include? label

            words = line.split(/\s/)
            words.each do |word|
              next unless (word =~ /^#.*/)&.zero?

              @new_lines += "#{replace(line, word, label, i)}\n"
            end
          end
        end

        # @api private
        def replace(line, issue_number, label, index)
          identifier = "#{label.split(/\s/)[0]} #{issue_number}"
          humanized = "#{link_to_humanize[index]} #{issue_number}"
          linked = "[#{humanized}](#{link_to_sites[index]}\/#{issue_number.tr('^0-9', '')})"

          line.gsub! identifier, linked
          line
        end
        # :nocov:
      end
    end
  end
end
