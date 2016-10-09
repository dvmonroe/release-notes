# frozen_string_literal: true
module Release
  module Notes
    class Linker
      attr_reader :config, :line

      delegate :link_to_labels, :link_to_sites, :link_to_humanize, to: :config

      def initialize(config)
        @config = config
      end

      def linkify(line)
        @line = line

        link_to_labels.each_with_index do |label, i|
          return line unless line.include? label
          words = line.split(/\s/)
          words.each do |word|
            next unless (word =~ /^#.*/)&.zero?
            return replace(word, label, i)
          end
        end
      end

      private

      def replace(issue_number, label, index)
        identifier = "#{label.split(/\s/)[0]} #{issue_number}"
        humanized = "#{link_to_humanize[index]} #{issue_number}"
        linked = "[#{humanized}](#{link_to_sites[index]})"

        line.gsub! identifier, linked
        line
      end
    end
  end
end
