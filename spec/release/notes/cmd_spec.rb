# frozen_string_literal: true

require "spec_helper"

describe Release::Notes::Cmd do
  subject { described_class }

  describe "#generate" do
    it "shows information about the command with the use of help" do
      expect { subject.start(%w(help generate)) }.to output(/-t, [--tag=TAG]/).to_stdout
      expect { subject.start(%w(help generate)) }.to output(
        /The latest tag to use on the file title if the tag is not yet pushed/,
      ).to_stdout
    end
  end
end
