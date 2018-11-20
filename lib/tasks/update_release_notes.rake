# frozen_string_literal: true

namespace :update_release_notes do
  task run: :environment do
    puts 'generating release notes...'
    Release::Notes::Update.new.run
    puts 'done!'
  end
end
