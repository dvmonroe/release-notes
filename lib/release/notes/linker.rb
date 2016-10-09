# frozen_string_literal: true
module Release
  module Notes
    class Linker
      attr_reader :config

      delegate :site_links, :link_labels, to: :config

      def initialize(config)
        @config = config
      end

      def linkify(lines)
        link_labels.each_with_index do |label, i|
          # replace any occurence of the label in the line
          lines.gsub! label, "[#{label}](#{site_links[i]})"
          # replace with the correct link
        end
      end
    end
  end
end
