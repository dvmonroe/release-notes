# frozen_string_literal: true
require 'spec_helper'

describe Release::Notes::Configuration do
  after { restore_config }

  context 'when no output_file is configured' do
    it 'defaults to ./RELEASENOTES.md' do
      expect(Release::Notes.configuration.output_file).to eq './RELEASENOTES.md'
    end
  end

  describe '#include_merges?' do
    context 'when include_merges is configured to true' do
      it 'returns an empty string' do
        Release::Notes.configure { |config| config.include_merges = true }
        expect(Release::Notes.configuration.include_merges?).to eq ''
      end
    end

    context 'when include_merges has not been configured' do
      it 'returns --no-merges' do
        expect(Release::Notes.configuration.include_merges?).to eq '--no-merges'
      end
    end
  end

  describe '#regex_type' do
    context 'when extended_regex is configured to false' do
      it 'returns an empty string' do
        Release::Notes.configure { |config| config.extended_regex = false }
        expect(Release::Notes.configuration.regex_type).to eq ''
      end
    end

    context 'when extended_regex has not been configured' do
      it 'returns -E' do
        expect(Release::Notes.configuration.regex_type).to eq '-E'
      end
    end
  end

  describe '#grep_insensitive?' do
    context 'when case_insensitive_grep is configured to false' do
      it 'returns an empty string' do
        Release::Notes.configure { |config| config.case_insensitive_grep = false }
        expect(Release::Notes.configuration.grep_insensitive?).to eq ''
      end
    end

    context 'when case_insensitive_grep has not been configured' do
      it 'returns -i' do
        expect(Release::Notes.configuration.grep_insensitive?).to eq '-i'
      end
    end
  end

  describe '#by_release?' do
    context 'when by_release is configured to false' do
      it 'returns false' do
        Release::Notes.configure { |config| config.by_release = false }
        expect(Release::Notes.configuration.by_release?).to eq false
      end
    end

    context 'when by_release has not been configured' do
      it 'returns true' do
        expect(Release::Notes.configuration.by_release?).to eq true
      end
    end
  end

  describe '#bugs' do
    context 'when bug_labels is configured' do
      it 'returns a formatted string with the configured values' do
        Release::Notes.configure { |config| config.bug_labels = %w(foo bar boo) }
        expect(Release::Notes.configuration.bugs).to eq '(foo|bar|boo)'
      end
    end

    context 'when bug_labels has not been configured' do
      it 'returns true' do
        expect(Release::Notes.configuration.bugs).to eq '(Fix|Update)'
      end
    end
  end

  describe '#features' do
    context 'when feature_labels is configured' do
      it 'returns a formatted string with the configured values' do
        Release::Notes.configure { |config| config.feature_labels = %w(foo bar boo) }
        expect(Release::Notes.configuration.features).to eq '(foo|bar|boo)'
      end
    end

    context 'when feature_labels has not been configured' do
      it 'returns default formatted string' do
        expect(Release::Notes.configuration.features).to eq '(Add|Create)'
      end
    end
  end

  describe '#misc' do
    context 'when misc_labels is configured' do
      it 'returns a formatted string with the configured values' do
        Release::Notes.configure { |config| config.misc_labels = %w(foo bar boo) }
        expect(Release::Notes.configuration.misc).to eq '(foo|bar|boo)'
      end
    end

    context 'when feature_labels has not been configured' do
      it 'returns default formatted string' do
        expect(Release::Notes.configuration.misc).to eq '(Refactor)'
      end
    end
  end

  describe '#all_labels' do
    context 'when misc_labels is configured' do
      it 'returns a formatted string with the configured values' do
        Release::Notes.configure do |config|
          config.bug_labels = %w(hello)
          config.feature_labels = %w(foo bar)
          config.misc_labels = %w(world)
        end
        expect(Release::Notes.configuration.all_labels).to eq '(hello|foo|bar|world)'
      end
    end

    context 'when feature_labels has not been configured' do
      it 'returns the default formatted string' do
        expect(Release::Notes.configuration.all_labels).to eq '(Fix|Update|Add|Create|Refactor)'
      end
    end
  end
end
