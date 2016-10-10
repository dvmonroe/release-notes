# frozen_string_literal: true

namespace :update_release_notes do
  task run: :environment do
    Release::Notes::Update.new.run
  end
end
