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

  describe "using dates instead of tags for grouped commit titles" do
    before do
      Release::Notes.configure do |config|
        config.header_title = "date"
      end
      travel_to Time.zone.local(2018, 12, 20, 1, 5, 45)
    end

    after { travel_back }

    it "outputs the right commits under the right date" do
      within_spec_integration do
        (1..3).each { |v| 2.times { git_commit("Add me") } && git_tag(v) }
        Release::Notes::Cmd.start(["generate"])

        content = read_file

        file = <<~FILE
          # Release Notes

          ## December 20, 2018 01:05:45 AM EST

          **Implemented enhancements:**

          - Add me
          - Add me

          ## December 20, 2018 01:05:45 AM EST

          **Implemented enhancements:**

          - Add me
          - Add me

          ## December 20, 2018 01:05:45 AM EST

          **Implemented enhancements:**

          - Add me
        FILE

        expect(content).to eq(file)
      end
    end
  end
end
