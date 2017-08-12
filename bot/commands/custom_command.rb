# frozen_string_literal: true

module YayaBot
  module Commands
    class CustomCommand < Base
      custom_command do |client, data, match|
        binding.pry
      end
    end
  end
end
