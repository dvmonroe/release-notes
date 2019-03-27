# frozen_string_literal: true

module Release
  module Notes
    class Railtie < Rails::Railtie
      generators do
        require "generators/release/notes/install/install_generator.rb"
      end
    end
  end
end
