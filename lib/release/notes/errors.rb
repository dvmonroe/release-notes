# frozen_string_literal: true

module Release
  module Notes
    class MissingTag < ArgumentError; end
    class NotBoolean < TypeError; end
  end
end
