# frozen_string_literal: true

require "spec_helper"

describe Release::Notes::System do
  let(:klass) { described_class }
  subject { klass.new }

  describe "#log" do
    it "invokes Git.log" do
      expect_any_instance_of(klass).to receive(:log)
      subject.log
    end

    it "hits the cmd line with the right args" do
      expect_any_instance_of(klass).to receive(:`).with("git log ''..'' --grep='' -E -i --no-merges --format='%h - %s'")
      subject.log
    end

    context "with log_all arg" do
      it "hits the cmd line with the right args" do
        expect_any_instance_of(klass).to receive(:`).
          with("git log ''..'' --grep='(Fix|Update|Add|Create|Refactor) --invert-grep'" \
               " -E -i --no-merges --format='%h - %s'")
        klass.new(log_all: true).log
      end
    end
  end

  describe ".all_tags" do
    it "invokes Git.read_all_tags" do
      expect(Release::Notes::Git).to receive(:read_all_tags).and_return("foo")
      allow(Release::Notes::System).to receive(:`)
      klass.all_tags
    end

    it "hits the cmd line" do
      allow(Release::Notes::Git).to receive(:read_all_tags).and_return("foobar")
      expect(Release::Notes::System).to receive(:`).with("foobar").once
      klass.all_tags
    end

    it "returns the result of the system program" do
      allow(Release::Notes::System).to receive(:`).and_return("foo")
      expect(klass.all_tags).to eq "foo"
    end
  end

  describe ".last_tag" do
    it "invokes Git.last_tag" do
      expect(Release::Notes::Git).to receive(:last_tag).and_return("foo")
      allow(Release::Notes::System).to receive(:`)
      klass.last_tag
    end

    it "hits the cmd line" do
      allow(Release::Notes::Git).to receive(:last_tag).and_return("foobar")
      expect(Release::Notes::System).to receive(:`).with("foobar").once
      klass.last_tag
    end

    it "returns the result of the system program" do
      allow(Release::Notes::System).to receive(:`).and_return("foo")
      expect(klass.last_tag).to eq "foo"
    end
  end

  describe ".tag_date" do
    it "invokes Git.tag_date" do
      expect(Release::Notes::Git).to receive(:tag_date).and_return("foo")
      allow(Release::Notes::System).to receive(:`)
      klass.tag_date
    end

    it "returns the result of the system program" do
      allow(Release::Notes::System).to receive(:`).and_return("foo")
      expect(klass.tag_date).to eq "foo"
    end
  end
end
