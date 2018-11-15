# frozen_string_literal: true

namespace :update_release_notes do
  task run: :environment do
    p 'generating release notes...'
    Release::Notes::Update.new.run
    p 'done!'
  end
end
