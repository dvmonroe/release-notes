# frozen_string_literal: true

require "spec_helper"

RSpec.describe "install:run" do
  include_context "rake"

  before do
    allow(Release::Notes).to receive(:install) { true }
  end

  it "runs gracefully with no subscribers" do
    expect { subject.execute }.not_to raise_error
  end

  it "initalizes a new install" do
    expect(Release::Notes).to receive(:install).once
    subject.invoke
  end

  it "runs" do
    expect(Release::Notes.install).to eq true
    subject.invoke
  end

  it "should ouput text when run" do
    FakeFS do
      Library.add "./config/release_notes.rb"
      assert File.directory?("./config/release_notes.rb")
      expect(STDOUT).to receive(:warn).with("=> Generating release notes...")
      subject.invoke
    end
  end
end
