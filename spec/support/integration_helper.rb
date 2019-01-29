# frozen_string_literal: true

module IntegrationHelper
  def within_spec_integration(&_block)
    Dir.chdir "spec/integration" do
      yield
    end
  end

  def read_file
    File.read Release::Notes.configuration.output_file
  end

  def git_commit(msg)
    `git commit --date='#{Time.current}' --allow-empty -am '#{msg}'`
  end

  def git_tag(version)
    `git tag -f v0.#{version}.0 -m "Version 0.#{version}.0 release"`
  end

  def messages
    [
      "Fix Me",
      "Add this",
      "Refactor again",
    ]
  end
end
