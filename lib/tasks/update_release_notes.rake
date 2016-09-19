# frozen_string_literal: true
namespace :release_notes do
  task :update do
    Release::Notes.update
  end
end
