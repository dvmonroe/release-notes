# frozen_string_literal: true
require 'spec_helper'

describe Release::Notes::Git do
  describe '#log' do
    context 'with default configuration' do
      subject { described_class }
      let(:config) { Release::Notes.configuration }
      let(:last_tag) { Date.new(2016, 9, 21).strftime('%Y-%m-%d') }
      let(:dates) { Release::Notes::DateFormatter.new(config, last_tag) }

      before :each do
        allow_any_instance_of(subject).to receive(:first_commit)
          .and_return(last_tag)
      end
      context 'basic flags' do
        it 'returns a string that includes default git log flags' do
          @new_cmd = system_cmd.log(config.bugs)

          expect(@new_cmd).to include 'git log'
          expect(@new_cmd).to include "--format='-%s'"
          expect(@new_cmd).to include '--since'
          expect(@new_cmd).to include '--until'
          expect(@new_cmd).to include '-E -i --no-merges'
        end
      end

      let(:system_cmd) { subject.new(config, dates) }
      context 'bugs' do
        it 'grep flag includes correct regex' do
          expect(system_cmd.log(config.bugs)).to include "--grep='(Fix|Update)'"
        end
      end

      context 'features' do
        it 'grep flag includes correct regex' do
          expect(system_cmd.log(config.features)).to include "--grep='(Add|Create)'"
        end
      end

      context 'misc' do
        it 'grep flag includes correct regex' do
          expect(system_cmd.log(config.misc)).to include "--grep='(Refactor)'"
        end
      end

      context 'all' do
        it 'grep flag includes correct regex' do
          expect(system_cmd.log(config.all_labels)).to include "--grep='(Fix|Update|Add|Create|Refactor)'"
        end
      end
    end
  end

  describe '#sorted_log' do
  end
end
