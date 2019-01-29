# frozen_string_literal: true

require "spec_helper"

describe Release::Notes do
  subject { described_class }

  it "has a version number" do
    expect(Release::Notes::VERSION).not_to be nil
  end
end
