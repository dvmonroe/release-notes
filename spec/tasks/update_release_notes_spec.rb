# frozen_string_literal: true
require 'spec_helper'

RSpec.describe 'update_release_notes:run' do
  include_context 'rake'

  before do
    allow_any_instance_of(Release::Notes::Update).to receive(:run) { true }
  end

  describe 'basic rake' do
    subject { super().prerequisites }
    it { is_expected.to include('environment') }
  end

  it 'initalizes a new update' do
    expect_any_instance_of(Release::Notes::Update).to receive(:run).once
    subject.invoke
  end
end
