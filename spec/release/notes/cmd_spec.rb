# frozen_string_literal: true

require "spec_helper"

describe Release::Notes::Cmd do
  subject { described_class }

  describe "#help" do
    context "with generate" do
      it "shows information about tag flag" do
        expect { subject.start(%w(help generate)) }.to output(
          Regexp.new(Regexp.escape("-t, [--tag=TAG]")),
        ).to_stdout
        expect { subject.start(%w(help generate)) }.to output(
          /The latest tag to use on the file title if the tag is not yet pushed/,
        ).to_stdout
      end

      it "shows information about ignore-head flag" do
        expect { subject.start(%w(help generate)) }.to output(
          Regexp.new(Regexp.escape("-i, [--ignore-head], [--no-ignore-head]")),
        ).to_stdout
        expect { subject.start(%w(help generate)) }.to output(
          / If updating your changelog and you don't want the latest commits from the last tag to HEAD in a single instance of running, set to true/, # rubocop:disable Metrics/LineLength
        ).to_stdout
      end

      it "shows information about rewrite flag" do
        expect { subject.start(%w(help generate)) }.to output(
          Regexp.new(Regexp.escape("-r, [--rewrite], [--no-rewrite]")),
        ).to_stdout
        expect { subject.start(%w(help generate)) }.to output(
          /Force release-notes to look at all previous tags and rewrite the output file/,
        ).to_stdout
      end
    end
  end
end
