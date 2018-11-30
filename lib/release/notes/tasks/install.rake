# frozen_string_literal: true

namespace :"release:notes" do
  desc "Install release notes in a non Rails environment"
  task :install do
    config_file = File.expand_path("../../../generators/release/notes/install/templates/release_notes.rb", __dir__)

    if File.exist?("./config/release_notes.rb")
      warn "=> [ skipping ] config/release_notes.rb already exists"
    else
      FileUtils.cp(config_file, "./config/release_notes.rb")
      warn "=> config/release_notes.rb created"
    end
  end
end
