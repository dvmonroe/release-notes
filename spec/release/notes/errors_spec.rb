# frozen_string_literal: true

require "spec_helper"

describe Release::Notes::MissingTag do
  subject { described_class }

  it { expect(subject.superclass).to eq(ArgumentError) }
end

describe Release::Notes::NotBoolean do
  subject { described_class }

  it { expect(subject.superclass).to eq(TypeError) }
end
