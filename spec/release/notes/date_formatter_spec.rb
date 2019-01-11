# frozen_string_literal: true

require "spec_helper"

describe Release::Notes::DateFormatter do
  subject { Release::Notes::DateFormatter.new }

  describe "humanized" do
    it "formats the current time" do
      expect(subject.humanize).to eq Time.zone.now.strftime("%B %d, %Y %r %Z")
    end
  end
end
