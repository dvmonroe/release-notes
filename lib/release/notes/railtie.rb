# frozen_string_literal: true

module Release
  module Notes
    class Railtie < Rails::Railtie
      rake_tasks do
        load 'tasks/update_release_notes.rake'
      end

      generators do
        require 'generators/release/notes/install/install_generator.rb'
      end
    end
  end
end
