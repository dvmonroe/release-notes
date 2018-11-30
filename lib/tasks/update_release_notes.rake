# frozen_string_literal: true

namespace :update_release_notes do
  task :run do
    puts "=> Generating release notes..."
    Release::Notes.generate
    puts "=> Done!"
  end
end
