# frozen_string_literal: true

require "spec_helper"

describe Release::Notes do
  after { restore_config }

  class TestClass
    include Release::Notes
    attr_reader :config

    def initialize(config)
      @config = config
    end

    def foobar
      log line: "fix this one too Refactor"
    end
  end

  let(:config) { Release::Notes.configuration }
  subject { TestClass.new(config) }

  describe "log" do
    it "removes the regex from the string" do
      expect(subject.foobar).to eq "this one too"
    end
  end
end
