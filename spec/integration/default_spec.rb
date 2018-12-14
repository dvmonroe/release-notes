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
    end
  end

  describe "default configuration for with nonexistent file" do
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
      end
    end
  end
end
