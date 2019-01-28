# frozen_string_literal: true

require "spec_helper"

describe Release::Notes::Write do
  let(:klass) { Release::Notes::Write }
  let(:file_like_object) { double("file_like_object") }
  let(:message) { "dates or titles\n" }
  subject { klass.new }

  describe "#digest" do
    it "creates a file" do
      allow(File).to receive(:open).with(subject.config_temp_file, "a").and_return(file_like_object)
      expect(subject.digest(message)).to eq file_like_object
    end
  end

  describe "#digest_date" do
    let(:date) { Time.now.to_s }
    it "sends a string to digest" do
      allow(subject).to receive(:digest_date).with(date)
      subject.stub(:digest_title).with(date)
    end
  end

  describe "#digest_title" do
    let(:title) { "a title" }
    let(:log) { "a log" }
    it "sends a string to digest" do
      allow(subject).to receive(:digest_title).with(title, log)
      subject.stub(:digest_title).with(title, log)
    end
  end

  describe "#write_new_file" do
    it "appends old file to new temp file" do
      allow(FileUtils).to receive(:cp).
        with(subject.config_temp_file, subject.config_output_file).
        and_return(file_like_object)

      expect(subject.write_new_file).to eq [subject.config_temp_file]
    end

    it "overwrites output file with tmp file" do
      allow(FileUtils).to receive(:rm).with(subject.config_temp_file).and_return(file_like_object)
      expect(subject.write_new_file).to eq file_like_object
    end
  end
end
