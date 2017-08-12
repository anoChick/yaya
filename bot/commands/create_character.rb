# frozen_string_literal: true

module YayaBot
  module Commands
    class CreateCharacter < Base
      command 'キャラ作成'
      command 'charac'

      def self.call(client, data, match)
        new_chara_name, new_chara_icon_url = match[:expression].split(' ')
        character = Character.find_or_create_by(name: new_chara_name)
        character.update!(user: current_user)
        character.update!(icon_url: new_chara_icon_url.delete('<').delete('>')) if new_chara_icon_url.present?

        client.web_client.chat_postMessage(
          channel: data.channel,
          text: "[#{character.name}]が新しく作成されました",
          username: character.name,
          icon_url: character.icon_url
        )
      rescue => e
        client.say(channel: channel_id, text: e.message)
      end
    end
  end
end
