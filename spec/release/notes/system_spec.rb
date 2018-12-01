# frozen_string_literal: true

require "spec_helper"

describe Release::Notes::System do
  let(:klass) { Release::Notes::System }

  describe "#system_log" do
    it "calls Git.system_log" do
      expect(Release::Notes::System).to receive(:system_log).and_return("foo")
      allow(Release::Notes::System).to receive(:`)
      klass.system_log
    end

    it "returns the result of the system log" do
      allow(Release::Notes::System).to receive(:system_log).and_return("foo")
      expect(klass.system_log).to eq "foo"
    end

    it "returns the result of the system log" do
      allow(Release::Notes::System).to receive(:system_log).with(log_all: true).and_return("bar")
      expect(klass.system_log(log_all: true)).to eq "bar"
    end
  end

  describe "#all_tags" do
    it "calls Git.read_all_tags" do
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
    it "calls Git.system_last_tag" do
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
    it "calls Git.tag_date" do
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
