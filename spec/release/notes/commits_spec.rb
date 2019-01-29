# frozen_string_literal: true

require "spec_helper"

describe Release::Notes::Commits do
  subject { described_class }

  it "defines REGEX_DELIMETER" do
    expect(subject::REGEX_DELIMETER).to eq(/(?=-)/)
  end
end
