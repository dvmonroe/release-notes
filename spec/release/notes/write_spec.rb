# frozen_string_literal: true

require "spec_helper"

describe Release::Notes::Write do
  after { restore_config }

  let(:klass) { Release::Notes::Write }
  let(:config) { Release::Notes.configuration }
  let(:file_like_object) { double("file_like_object") }

  subject { klass.new(config) }

  describe "#digest" do
    it "creates a file" do
      allow(File).to receive(:open).with(subject.temp_file, 'a').and_return(file_like_object)
      expect(subject.digest).to eq file_like_object
    end
  end

  describe "#write_new_file" do
    it "appends old file to new temp file" do
      allow(FileUtils).to receive(:cp).with(subject.temp_file, subject.output_file).and_return(file_like_object)
      expect(subject.write_new_file).to eq [subject.temp_file]
    end

    it "overwrites output file with tmp file" do
      allow(FileUtils).to receive(:rm).with(subject.temp_file).and_return(file_like_object)
      expect(subject.write_new_file).to eq file_like_object
    end
  end
end
