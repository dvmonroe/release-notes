# frozen_string_literal: true

require "spec_helper"

describe Release::Notes::Prettify do
  subject { Release::Notes::Prettify.new(line: "fix this one too Refactor") }

  describe "#perform" do
    it "removes the regex from the string" do
      expect(subject.perform).to eq "this one too"
    end
  end
end
