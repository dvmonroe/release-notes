# frozen_string_literal: true

require "spec_helper"

describe Release::Notes::WithConfiguration do
  class WithConfigurationTestClass
    include Release::Notes::WithConfiguration
    attr_reader :config, :date_formatter

    def initialize(config, _dates)
      @config = config
    end
  end

  describe "#with_config" do
    let(:klass) { WithConfigurationTestClass }
    let(:config) { Release::Notes.configuration }
    let(:dates) { Release::Notes::DateFormat.new(config) }
    subject { klass.new(config, dates) }

    it "creates a config object" do
      obj = subject.with_config { config }
      expect(obj).to be_kind_of(Release::Notes::Configuration)
      expect(obj).to have_attributes(all_labels: "(Fix|Update|Add|Create|Refactor)", timezone: "America/New_York")
    end
  end
end
