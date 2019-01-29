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

  describe "--ignore-head" do
    it "it only outputs up to the latest tag" do
      within_spec_integration do
        git_commit("Initial commit")
        git_commit("Fix me")
        git_tag(1)

        git_commit("Refactor a bunch")

        Release::Notes::Cmd.start(["generate", "--ignore-head"])

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
  end
end
