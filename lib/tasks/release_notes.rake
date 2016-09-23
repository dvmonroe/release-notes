# frozen_string_literal: true
namespace :release_notes do
  task update: :environment do
    Release::Notes::Update.new.run
  end
end
