# frozen_string_literal: true

require "whirly"

namespace :update_release_notes do
  task run: :environment do
    Whirly.start spinner: "dots", status: "Generating release-notes...", remove_after_stop: true do
      Release::Notes::Update.new.run
    end
  end
end
