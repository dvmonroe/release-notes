# frozen_string_literal: true

require "spec_helper"

describe Release::Notes::WithConfiguration do
  class TestClass
    include Release::Notes::WithConfiguration
    attr_reader :config, :date_formatter

    def initialize(config)
      @config = config
    end
  end

  describe "#with_config" do
    let(:klass) { TestClass }
    let(:config) { Release::Notes.configuration }
    subject { klass.new(config) }

    it "creates a config object" do
      obj = subject.with_config { config }
      expect(obj).to be_kind_of(Release::Notes::Configuration)
      expect(obj).to have_attributes(all_labels: "(Fix|Update|Add|Create|Refactor)", timezone: "America/New_York")
    end
  end
end
