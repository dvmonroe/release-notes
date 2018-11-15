# frozen_string_literal: true

require "spec_helper"

describe Release::Notes::Link do
  class LinkTestClass
    include Release::Notes::Link
    attr_reader :config, :link_to_labels, :link_to_humanize, :link_to_sites

    def initialize(config)
      @config = config
      @link_to_labels = ["HB #"]
      @link_to_humanize = ["Honeybadger"]
      @link_to_sites = ['https:\/\/app.honeybadger.io\/projects']
    end
  end

  describe "#log" do
    let(:klass) { LinkTestClass }
    let(:config) { Release::Notes.configuration }
    let(:lines) { "HB #345 This is the first line" }
    subject { klass.new(config) }

    context "#link_lines" do
      it "adds links to labels" do
        expect(subject.link_lines(lines: lines)).to eq "[Honeybadger #345](https:\\/\\/app.honeybadger.io\\/projects) This is the first line\n"
      end
    end
  end
end
