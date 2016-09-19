# frozen_string_literal: true
require 'rails/generators/base'

module Release
  module Notes
    module Generators
      class InstallGenerator < Rails::Generators::Base
        source_root File.expand_path('../templates', __FILE__)

        def create_release_notes_initializer
          copy_file 'release_notes.rb', 'config/initializers/release_notes.rb'
        end

        def display_readme
          readme 'README'
        end
      end
    end
  end
end