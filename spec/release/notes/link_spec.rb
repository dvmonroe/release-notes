# frozen_string_literal: true

require "spec_helper"

describe Release::Notes::Link do
  class LinkTestClass
    include Release::Notes::Link
    attr_reader :config

    def initialize(config)
      @config = config
    end
  end

  describe "#log" do
    let(:klass) { LinkTestClass }
    let(:config) { Release::Notes.configuration }
    let(:lines) do

    end
    subject { klass.new(config) }

    context "#link_lines" do
      it "splits the lines" do
        expect(subject.link_lines(lines: lines)).to eq lines.split(/\s/)
      end
    end
  end
end
