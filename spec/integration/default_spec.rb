# frozen_string_literal: true

require "spec_helper"
require "integration_helper"

describe Release::Notes do
  include IntegrationHelper

  before do
    within_spec_integration { `git init` }
  end

  after do
    within_spec_integration do
      `rm #{Release::Notes.configuration.output_file}`
      `rm -rf .git`
    end
  end

  describe "default configuration for nonexistent file" do
    it "the file is created" do
      within_spec_integration do
        (1..2).each { |v| git_commit(messages.sample) && git_tag(v) }
        Release::Notes.generate

        expect(File).to exist(Release::Notes.configuration.output_file)
      end
    end

    it "the file contains all the git tags" do
      within_spec_integration do
        (1..4).each { |v| 2.times { git_commit(messages.sample) } && git_tag(v) }
        Release::Notes.generate

        content = read_file

        expect(content).to include("## v0.4.0")
        expect(content).to include("## v0.3.0")
        expect(content).to include("## v0.2.0")
        expect(content).to include("## v0.1.0")
      end
    end

    it "the file contains the right commit under the right tag" do
      within_spec_integration do
        2.times { git_commit("Fix me") } && git_tag(1)
        Release::Notes.generate

        content = read_file

        file = <<~FILE
          # Release Notes

          ## v0.1.0

          **Fixed bugs:**

          - Fix me
        FILE

        expect(content).to eq(file)
      end
    end

    it "the file does not duplicate commits if it matches multuple labels" do
      within_spec_integration do
        2.times { git_commit("Fix me\n\n Add Me") } && git_tag(1)
        Release::Notes.generate

        content = read_file

        file = <<~FILE
          # Release Notes

          ## v0.1.0

          **Implemented enhancements:**

          - Fix me
        FILE

        expect(content).to eq(file)
      end
    end
  end

  describe "default configuration for file that already exists" do
    it "adds new commits" do
      within_spec_integration do
        git_commit("Initial commit") 
        git_commit("Fix me")
        git_tag(1)

        Release::Notes.generate

        git_commit("Refactor a bunch")
        git_tag(2)

        Release::Notes.generate

        content = read_file

        file = <<~FILE
          # Release Notes

          ## v0.2.0

          **Miscellaneous:**

          - Refactor a bunch

          ## v0.1.0

          **Fixed bugs:**

          - Fix me
        FILE

        expect(content).to eq(file)
      end
    end
  end
end
