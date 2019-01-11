# frozen_string_literal: true

module Release
  module Notes
    module Configurable
      delegate :timezone, :grep_insensitive?, :regex_type,
               :include_merges?, :link_to_labels, :link_to_sites, :link_to_humanize,
               :log_all, :header_title, :header_title_type, :features,
               :bugs, :misc, :feature_title,
               :bug_title, :misc_title, :log_all_title, :single_label,
               :output_file, :temp_file, :link_commits?, :all_labels,
               :prettify_messages?, :release_notes_exist?,
               :force_rewrite, prefix: :config, to: :"Release::Notes.configuration"
    end
  end
end
