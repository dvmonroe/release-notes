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

  describe "errors if no tag is passed" do
    it "raises a MissingTag error" do
      within_spec_integration do
        git_commit("Initial commit")
        git_commit("Fix me")
        git_tag(1)

        Release::Notes::Cmd.start(["generate"])

        git_commit("Refactor a bunch")

        expect { Release::Notes::Cmd.start(["generate"]) }.to raise_error(Release::Notes::MissingTag)
      end
    end
  end
end
