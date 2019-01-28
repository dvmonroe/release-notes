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
    subject { klass.new(config) }

    describe "#link_lines" do
      context "config is generic" do
        let(:lines) { "HB #345 This is the first line\n" }

        it "does not add links to labels" do
          expect(subject.link_lines(lines: lines)).to eq lines
        end
      end

      context "labels exist" do
        let(:config_link_to_labels) { ["AB #", "BC #"] }
        let(:config_link_to_humanize) { %w(LabelAB LabelBC) }
        let(:config_link_to_sites) { ["https:\/\/label_AB\/projects\/", "https:\/\/label_BC\/projects\/"] }

        before :each do
          allow_any_instance_of(klass).to receive(:config_link_to_labels).
            and_return(config_link_to_labels)
          allow_any_instance_of(klass).to receive(:config_link_to_humanize).
            and_return(config_link_to_humanize)
          allow_any_instance_of(klass).to receive(:config_link_to_sites).
            and_return(config_link_to_sites)
        end

        context "one label" do
          let(:lines) { "AB #345 This is the first line" }

          it "it adds link to label" do
            expect(subject.link_lines(lines: lines)).to eq(
              "[LabelAB #345](https:\/\/label_AB\/projects\/345) This is the first line\n",
            )
          end
        end

        context "more than one label" do
          let(:lines) { "AB #345 This is the first line.\nBC #543 This is the first line.\n" }

          it "it adds links to labels" do
            expect(subject.link_lines(lines: lines)).to eq(
              "[LabelAB #345](https:\/\/label_AB\/projects\/345) This is the first line.\n" \
              "[LabelBC #543](https:\/\/label_BC\/projects\/543) This is the first line.\n",
            )
          end
        end
      end
    end
  end
end
