# frozen_string_literal: true

require "spec_helper"

RSpec.describe "release:notes:install" do
  include IntegrationHelper

  let(:rake)      { Rake::Application.new }
  let(:task_name) { self.class.top_level_description }
  let(:task_path) { "../lib/release/notes/tasks/install" }
  let(:config_file) { "./config/release_notes.rb" }
  subject { rake[task_name] }

  def loaded_files_excluding_current_rake_file
    $LOADED_FEATURES.reject { |file| file == [Release::Notes.root].join("#{task_path}.rake").to_s }
  end

  before do
    Rake.application = rake
    Rake.application.rake_require(task_path, [Release::Notes.root.to_s], loaded_files_excluding_current_rake_file)

    Rake::Task.define_task(:environment)
  end

  after do
    within_spec_integration do
      FileUtils.rm_f config_file
    end
  end

  context "with no current config/release_notes.rb" do
    it "should create a new release_notes.rb file" do
      within_spec_integration do
        subject.invoke
        expect(Pathname.new(config_file)).to exist
      end
    end

    it "creates a new file with the right content" do
      within_spec_integration do
        subject.invoke
        path = Pathname.new config_file

        expect(File.read(path)).to match(/# frozen_string_literal: true/)
        expect(File.read(path)).to match(/Release::Notes.configure do |config|/)
      end
    end

    it "outputs a message" do
      within_spec_integration do
        expect { subject.invoke }.to output("=> config/release_notes.rb created\n").to_stderr
      end
    end
  end

  context "with current config/release_notes.rb" do
    it "does nothing to the current file" do
      within_spec_integration do
        contents = <<~FILE
          Foobar
        FILE

        File.open(config_file, "w") do |file|
          file.write contents
        end

        subject.invoke
        path = Pathname.new config_file
        expect(path).to exist
        expect(File.read(path)).to eq("Foobar\n")
      end
    end

    it "outputs a message" do
      within_spec_integration do
        contents = <<~FILE
          Foobar
        FILE

        File.open(config_file, "w") do |file|
          file.write contents
        end

        expect { subject.invoke }.to output("=> [ skipping ] config/release_notes.rb already exists\n").to_stderr
      end
    end
  end
end
