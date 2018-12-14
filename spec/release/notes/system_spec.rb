# frozen_string_literal: true

require "spec_helper"

describe Release::Notes::System do
  let(:klass) { Release::Notes::System }
  subject { FakeSystemClass.new }

  class FakeSystemClass
    include Release::Notes::System
  end

  describe "#system_log" do
    it "invokes Git.system_log" do
      expect(subject).to receive(:system_log)
      subject.system_log
    end

    it "hits the cmd line with the right args" do
      expect(subject).to receive(:`).with("git log ''..'' --grep='' -E -i --no-merges --format='%h - %s'")
      subject.system_log
    end

    context "with log_all arg" do
      it "invokes Git.system_log with { log_all: true }" do
        expect(subject).to receive(:system_log).with(log_all: true)
        subject.system_log(log_all: true)
      end

      it "hits the cmd line with the right args" do
        expect(subject).to receive(:`).
          with("git log ''..'' --grep='(Fix|Update|Add|Create|Refactor) --invert-grep'" \
               " -E -i --no-merges --format='%h - %s'")
        subject.system_log(log_all: true)
      end
    end
  end

  describe "#all_tags" do
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

  describe "#system_last_tag" do
    it "invokes Git.system_last_tag" do
      expect(Release::Notes::Git).to receive(:last_tag).and_return("foo")
      allow(Release::Notes::System).to receive(:`)
      klass.system_last_tag
    end

    it "hits the cmd line" do
      allow(Release::Notes::Git).to receive(:last_tag).and_return("foobar")
      expect(Release::Notes::System).to receive(:`).with("foobar").once
      klass.system_last_tag
    end

    it "returns the result of the system program" do
      allow(Release::Notes::System).to receive(:`).and_return("foo")
      expect(klass.system_last_tag).to eq "foo"
    end
  end

  describe "#tag_date" do
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
