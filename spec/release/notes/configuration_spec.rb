# frozen_string_literal: true

require "spec_helper"

describe Release::Notes::Configuration do
  after { restore_config }

  context "when no output_file is configured" do
    it "defaults to ./RELEASENOTES.md" do
      expect(Release::Notes.configuration.output_file).to eq "./RELEASE_NOTES.md"
    end
  end

  describe "#header_title_type" do
    context "when header_title is configured to tag" do
      it "returns tag" do
        Release::Notes.configure { |config| config.header_title = "tag" }
        expect(Release::Notes.configuration.header_title_type).to eq "tag"
      end
    end

    context "when header_title is configured to date" do
      it "returns date" do
        Release::Notes.configure { |config| config.header_title = "date" }
        expect(Release::Notes.configuration.header_title_type).to eq "date"
      end
    end

    context "when header_title is configured incorrectly" do
      it "returns tag" do
        Release::Notes.configure { |config| config.header_title = "random" }
        expect(Release::Notes.configuration.header_title_type).to eq "tag"
      end
    end
  end

  describe "#include_merges?" do
    context "when include_merges is configured to true" do
      it "returns an empty string" do
        Release::Notes.configure { |config| config.include_merges = true }
        expect(Release::Notes.configuration.include_merges?).to eq ""
      end
    end

    context "when include_merges has not been configured" do
      it "returns --no-merges" do
        expect(Release::Notes.configuration.include_merges?).to eq "--no-merges"
      end
    end
  end

  describe "#regex_type" do
    context "when extended_regex is configured to false" do
      it "returns an empty string" do
        Release::Notes.configure { |config| config.extended_regex = false }
        expect(Release::Notes.configuration.regex_type).to eq ""
      end
    end

    context "when extended_regex has not been configured" do
      it "returns -E" do
        expect(Release::Notes.configuration.regex_type).to eq "-E"
      end
    end
  end

  describe "#grep_insensitive?" do
    context "when ignore_case is configured to false" do
      it "returns an empty string" do
        Release::Notes.configure { |config| config.ignore_case = false }
        expect(Release::Notes.configuration.grep_insensitive?).to eq ""
      end
    end

    context "when ignore_case has not been configured" do
      it "returns -i" do
        expect(Release::Notes.configuration.grep_insensitive?).to eq "-i"
      end
    end
  end

  describe "#bugs" do
    context "when bug_labels is configured" do
      it "returns a formatted string with the configured values" do
        Release::Notes.configure { |config| config.bug_labels = %w(foo bar boo) }
        expect(Release::Notes.configuration.bugs).to eq "(foo|bar|boo)"
      end
    end

    context "when bug_labels has not been configured" do
      it "returns true" do
        expect(Release::Notes.configuration.bugs).to eq "(Fix|Update)"
      end
    end
  end

  describe "#features" do
    context "when feature_labels is configured" do
      it "returns a formatted string with the configured values" do
        Release::Notes.configure { |config| config.feature_labels = %w(foo bar boo) }
        expect(Release::Notes.configuration.features).to eq "(foo|bar|boo)"
      end
    end

    context "when feature_labels has not been configured" do
      it "returns default formatted string" do
        expect(Release::Notes.configuration.features).to eq "(Add|Create)"
      end
    end
  end

  describe "#misc" do
    context "when misc_labels is configured" do
      it "returns a formatted string with the configured values" do
        Release::Notes.configure { |config| config.misc_labels = %w(foo bar boo) }
        expect(Release::Notes.configuration.misc).to eq "(foo|bar|boo)"
      end
    end

    context "when feature_labels has not been configured" do
      it "returns default formatted string" do
        expect(Release::Notes.configuration.misc).to eq "(Refactor)"
      end
    end
  end

  describe "#all_labels" do
    context "when misc_labels is configured" do
      it "returns a formatted string with the configured values" do
        Release::Notes.configure do |config|
          config.bug_labels = %w(hello)
          config.feature_labels = %w(foo bar)
          config.misc_labels = %w(world)
        end
        expect(Release::Notes.configuration.all_labels).to eq "(hello|foo|bar|world)"
      end
    end

    context "when feature_labels has not been configured" do
      it "returns the default formatted string" do
        expect(Release::Notes.configuration.all_labels).to eq "(Fix|Update|Add|Create|Refactor)"
      end
    end
  end

  describe "#release_notes_exist?" do
    context "when output file does exist" do
      it "returns true" do
        allow(Release::Notes.configuration).to receive(:release_notes_exist?).and_return(true)
        expect(Release::Notes.configuration.release_notes_exist?).to eq true
      end
    end
    context "when output file does not exist" do
      it "returns false" do
        if Release::Notes.configuration.release_notes_exist?
          File.delete(Release::Notes.configuration.output_file)
          expect(Release::Notes.configuration.release_notes_exist?).to eq false
        end
      end
    end

    context "when output file does exist" do
      it "returns true" do
        allow(File).to receive(:exist?).and_return(true)
        expect(Release::Notes.configuration.release_notes_exist?).to eq true
      end
    end
  end

  describe "#link_commits?" do
    context "when link_to_# has not been configured" do
      it "returns false" do
        expect(Release::Notes.configuration.link_commits?).to eq false
      end
    end

    context "when link_to_# has been configured" do
      it "returns true if link_to_labels, link_to_humanize, and link_to_sites are all present" do
        Release::Notes.configure do |config|
          config.link_to_labels = %w(hello)
          config.link_to_humanize = %w(foo bar)
          config.link_to_sites = %w(world)
        end
        expect(Release::Notes.configuration.link_commits?).to eq true
      end

      it "returns false if link_to_labels is not present" do
        Release::Notes.configure do |config|
          config.link_to_humanize = %w(foo bar)
          config.link_to_sites = %w(world)
        end
        expect(Release::Notes.configuration.link_commits?).to eq false
      end

      it "returns false if link_to_humanize is not present" do
        Release::Notes.configure do |config|
          config.link_to_labels = %w(hello)
          config.link_to_sites = %w(world)
        end
        expect(Release::Notes.configuration.link_commits?).to eq false
      end

      it "returns false if link_to_sites is not present" do
        Release::Notes.configure do |config|
          config.link_to_labels = %w(hello)
          config.link_to_humanize = %w(foo bar)
        end
        expect(Release::Notes.configuration.link_commits?).to eq false
      end
    end
  end

  describe "#prettify_messages?" do
    context "when prettify_messages has been configured" do
      it "returns false if configured to be false" do
        Release::Notes.configure { |config| config.prettify_messages = false }
        expect(Release::Notes.configuration.prettify_messages?).to eq false
      end

      it "returns true if configured to be true" do
        Release::Notes.configure { |config| config.prettify_messages = true }
        expect(Release::Notes.configuration.prettify_messages?).to eq true
      end
    end

    context "when prettify_messages has not been configured" do
      it "defaults to false" do
        expect(Release::Notes.configuration.prettify_messages?).to eq false
      end
    end
  end

  describe "#for_each_ref_foramt" do
    context "when for_each_ref_format has been configured" do
      it "returns the configured value" do
        Release::Notes.configure { |config| config.for_each_ref_format = "refname:lstrip=-1" }
        expect(Release::Notes.configuration.for_each_ref_format).to eq "refname:lstrip=-1"
      end
    end

    context "when prettify_messages has not been configured" do
      it "defaults to tag" do
        expect(Release::Notes.configuration.for_each_ref_format).to eq "tag"
      end
    end
  end
end
