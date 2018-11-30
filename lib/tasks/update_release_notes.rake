# frozen_string_literal: true

namespace :update_release_notes do
  task :run do
    puts "generating release notes..."
    Release::Notes.generate
    puts "done!"
  end
end
