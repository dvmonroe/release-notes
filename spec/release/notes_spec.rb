# frozen_string_literal: true

require "spec_helper"

describe Release::Notes::Update do
  subject { described_class.new }

  it "has a version number" do
    expect(Release::Notes::VERSION).not_to be nil
  end

  describe "#run" do
    it "calls updater" do
      expect_any_instance_of(Release::Notes::Log).to receive(:perform)
      subject.run
    end
  end
end
