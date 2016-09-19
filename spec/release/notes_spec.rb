# frozen_string_literal: true
require 'spec_helper'

describe Release::Notes do
  it 'has a version number' do
    expect(Release::Notes::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(true)
  end
end
