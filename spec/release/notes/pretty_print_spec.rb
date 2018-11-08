# frozen_string_literal: true

require "spec_helper"

describe Release::Notes::PrettyPrint do
  class TestClass
    include Release::Notes::PrettyPrint
    attr_reader :config

    def initialize(config)
      @config = config
    end

    def foobar
      prettify line: "fix this one too Refactor"
    end
  end

  let(:config) { Release::Notes.configuration }
  subject { TestClass.new(config) }

  describe "prettify" do
    it "removes the regex from the string" do
      expect(subject.foobar).to eq "this one too"
    end
  end
end
