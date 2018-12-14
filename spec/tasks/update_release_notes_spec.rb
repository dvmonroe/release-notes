# frozen_string_literal: true

require "spec_helper"
require "shared_contexts/rake"

RSpec.describe "update_release_notes:run" do
  include_context "rake"

  before do
    allow(Release::Notes).to receive(:generate) { true }
  end

  it "runs gracefully with no subscribers" do
    expect { subject.execute }.not_to raise_error
  end

  it "initalizes a new update" do
    expect(Release::Notes).to receive(:generate).once
    subject.invoke
  end

  it "runs" do
    expect(Release::Notes.generate).to eq true
    subject.invoke
  end

  it "should ouput text when run" do
    expect(STDOUT).to receive(:puts).with("=> Generating release notes...")
    expect(STDOUT).to receive(:puts).with("=> Done!")
    subject.invoke
  end
end
