# frozen_string_literal: true

module YayaBot
  module Commands
    class CustomCommand < Base
      custom_command do |client, data, match|
        command_name = match['command']
        return post_message("[#{command_name}は記録されていません。]")if current_character.codes.find_by(name: command_name).nil?

        ExecCommandJob.perform(data.to_json)
        #ExecCommandJob.perform_later(data.to_json)
      end
    end
  end
end
