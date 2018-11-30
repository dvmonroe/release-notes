# frozen_string_literal: true

require "spec_helper"

describe Release::Notes do
  subject { described_class }

  it "has a version number" do
    expect(Release::Notes::VERSION).not_to be nil
  end

  describe "#run" do
    it "calls updater" do
      expect_any_instance_of(Release::Notes::Log).to receive(:perform)
      subject.generate
    end
  end
end
