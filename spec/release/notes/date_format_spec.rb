# frozen_string_literal: true

require "spec_helper"

describe Release::Notes::DateFormat do
  let(:config) { Release::Notes.configuration }
  subject { Release::Notes::DateFormat.new }

  describe "date_humanized" do
    it "formats the current time" do
      expect(subject.date_humanized).to eq Time.zone.now.strftime("%B %d, %Y %r %Z")
    end
  end
end
