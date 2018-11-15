# frozen_string_literal: true

require "spec_helper"

describe Release::Notes::Write do
  class TestClass
    include Release::Notes::Write
    attr_reader :config

    def initialize(config)
      @config = config
    end
  end

  describe "#digest" do
    let(:klass) { TestClass }
    let(:config) { Release::Notes.configuration }
    subject { klass.new(config) }

    it "creates a file" do
    end
  end
end
