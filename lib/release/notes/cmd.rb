# frozen_string_literal: true

module Release
  module Notes
    class Cmd < Thor
      desc "generate", "Generate release notes"
      option :tag, desc: "The latest tag to use on the file title if the tag is not yet pushed", aliases: "-t"
      def generate
        warn "=> Generating release notes..."
        Log.new(options).perform
        warn "=> Done!"
      end
    end
  end
end
