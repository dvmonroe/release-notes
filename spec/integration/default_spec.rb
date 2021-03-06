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
    it "creates the file" do
      within_spec_integration do
        (1..2).each { |v| git_commit(messages.sample) && git_tag(v) }
        Release::Notes::Cmd.start(["generate"])

        expect(File).to exist(Release::Notes.configuration.output_file)
      end
    end

    it "creates the file that contains all the git tags" do
      within_spec_integration do
        (1..4).each { |v| 2.times { git_commit(messages.sample) } && git_tag(v) }
        Release::Notes::Cmd.start(["generate"])

        content = read_file

        expect(content).to include("## v0.4.0")
        expect(content).to include("## v0.3.0")
        expect(content).to include("## v0.2.0")
        expect(content).to include("## v0.1.0")
      end
    end

    it "outputs right commit under the right tag" do
      within_spec_integration do
        2.times { git_commit("Fix me") } && git_tag(1)
        Release::Notes::Cmd.start(["generate"])

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

    it "does not duplicate commits if it matches multuple labels" do
      within_spec_integration do
        2.times { git_commit("Fix me\n\n Add Me") } && git_tag(1)
        Release::Notes::Cmd.start(["generate"])

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

        Release::Notes::Cmd.start(["generate"])

        git_commit("Refactor a bunch")

        Release::Notes::Cmd.start(["generate", "-t", "v0.2.0"])

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

  describe "commit message contains `-` " do
    it "does not mess up formatting" do
      within_spec_integration do
        2.times { git_commit("Fix me - and more - this is more") } && git_tag(1)
        Release::Notes::Cmd.start(["generate"])

        content = read_file

        file = <<~FILE
          # Release Notes

          ## v0.1.0

          **Fixed bugs:**

          - Fix me - and more - this is more
        FILE

        expect(content).to eq(file)
      end
    end
  end

  describe "multiple commit messages for a single tag" do
    it "does not duplicate the headers" do
      within_spec_integration do
        (1..4).each { |v| 2.times { git_commit("Add me") } && git_tag(v) }
        Release::Notes::Cmd.start(["generate"])

        content = read_file

        file = <<~FILE
          # Release Notes

          ## v0.4.0

          **Implemented enhancements:**

          - Add me
          - Add me

          ## v0.3.0

          **Implemented enhancements:**

          - Add me
          - Add me

          ## v0.2.0

          **Implemented enhancements:**

          - Add me
          - Add me

          ## v0.1.0

          **Implemented enhancements:**

          - Add me
        FILE

        expect(content).to eq(file)
      end
    end
  end
end
