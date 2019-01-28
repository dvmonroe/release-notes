# frozen_string_literal: true

module Release
  module Notes
    module Configurable
      delegate :all_labels,
               :bug_title,
               :bugs,
               :feature_title,
               :features,
               :for_each_ref_format,
               :force_rewrite,
               :grep_insensitive_flag,
               :header_title_type,
               :link_commits?,
               :link_to_humanize,
               :link_to_labels,
               :link_to_sites,
               :log_all,
               :log_all_title,
               :merge_flag,
               :misc,
               :misc_title,
               :newest_tag,
               :output_file,
               :prettify_messages?,
               :regex_type,
               :release_notes_exist?,
               :single_label,
               :temp_file,
               :timezone,
               :update_release_notes_before_tag?,
               prefix: :config, to: :"Release::Notes.configuration"
    end
  end
end
