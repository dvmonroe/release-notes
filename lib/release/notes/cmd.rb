# frozen_string_literal: true

module Release
  module Notes
    class Cmd < Thor
      desc "generate", "Generate release notes"
      option :tag, type: :string,
                   aliases: "-t",
                   desc: "The latest tag to use on the file title if the tag is not yet pushed"
      option :'force-rewrite', type: :boolean,
                               default: false,
                               aliases: "-r",
                               desc: "Force release-notes to look at all previous "\
                             "tags and rewrite the output file"
      option :'ignore-head', type: :boolean,
                             default: false,
                             aliases: "-i",
                             desc: "If updating your changelog and you don't want the latest commits "\
                                    "from the last tag to HEAD in a single "\
                                    "instance of running, set to true"
      def generate
        warn "=> Generating release notes..."
        Log.new(options).perform
        warn "=> Done!"
      end
    end
  end
end
