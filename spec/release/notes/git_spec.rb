# frozen_string_literal: true

require "spec_helper"

describe Release::Notes::Git do
  class GitTestClass
    include Release::Notes::Git
    attr_reader :config, :date_formatter

    def initialize(config, _dates)
      @config = config
    end
  end

  describe "#log" do
    let(:klass) { GitTestClass }
    let(:last_tag) { Date.new(2016, 9, 21).strftime("%Y-%m-%d") }
    let(:config) { Release::Notes.configuration }
    let(:dates) { Release::Notes::DateFormat.new(config) }
    subject { klass.new(config, dates) }

    context "with default configuration" do
      before :each do
        allow_any_instance_of(klass).to receive(:first_commit).
          and_return(last_tag)
      end

      context "basic flags" do
        it "returns a string that includes default git log flags" do
          @new_cmd = subject.log(label: config.bugs)
          expect(@new_cmd).to include "git log"
          expect(@new_cmd).to include "--format='- %s'"
          expect(@new_cmd).to include "-E -i --no-merges"
        end
      end

      context "bugs" do
        it "grep flag includes correct regex" do
          expect(subject.log(label: config.bugs)).to include "--grep='(Fix|Update)'"
        end
      end

      context "features" do
        it "grep flag includes correct regex" do
          expect(subject.log(label: config.features)).to include "--grep='(Add|Create)'"
        end
      end

      context "misc" do
        it "grep flag includes correct regex" do
          expect(subject.log(label: config.misc)).to include "--grep='(Refactor)'"
        end
      end

      context "all" do
        it "grep flag includes correct regex" do
          expect(subject.log(label: config.all_labels)).to include "--grep='(Fix|Update|Add|Create|Refactor)'"
        end
      end
    end
  end

  describe "#last_tag" do
    it "returns command to get the last git tag" do
      expect(Release::Notes::Git.last_tag).to eq "git describe --abbrev=0 --tags"
    end
  end

  describe "#tag_date" do
    it "returns command to get date for the supplied tag" do
      expect(Release::Notes::Git.tag_date("v0.0.1")).to eq "git log -1 --format=%ai v0.0.1"
    end
  end

  describe "#read_all_tags" do
    it "returns command to get all tags" do
      expect(Release::Notes::Git.read_all_tags).to eq "git tags | sort -u -r"
    end
  end
end
