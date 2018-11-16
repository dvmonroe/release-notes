# frozen_string_literal: true

require "spec_helper"

describe Release::Notes::Link do
  after { restore_config }

  class TestClass
    include Release::Notes::Link
    attr_reader :config

    def initialize(config)
      @config = config
    end
  end

  describe "#log" do
    let(:klass) { TestClass }
    let(:config) { Release::Notes.configuration }
    let(:lines) do
      "This is the first line"\
      "This is the second line"\
      "This is the third line"
    end
  end
end
