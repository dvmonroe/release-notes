# frozen_string_literal: true

require "spec_helper"

describe Release::Notes::Write do
  class TestClass
    include Release::Notes
    attr_reader :config

    def initialize(config)
      @config = config
    end
  end

  describe "#digest" do
    let(:klass) { TestClass::Write }
    let(:config) { Release::Notes.configuration }
    let(:file_like_object) { double("file like object") }

    subject { klass.new(config) }

    it "creates a file" do
      allow(File).to receive(:open).with(subject.temp_file).and_return(file_like_object)
    end
  end

  describe "#write_new_file" do
    let(:klass) { TestClass::Write }
    let(:config) { Release::Notes.configuration }
    let(:file_like_object) { double("file like object") }

    subject { klass.new(config) }

    it "appends old file to new temp file" do
      allow(FileUtils).to receive(:cp).with(subject.temp_file, "~/").and_return(file_like_object)
    end

    it "overwrites output file with tmp file" do
      allow(FileUtils).to receive(:rm).with(subject.temp_file).and_return(file_like_object)
    end
  end
end
