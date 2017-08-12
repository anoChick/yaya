# frozen_string_literal: true

module YayaBot
  module Commands
    class CodeRegister < Base
      character_command '教える' do |client, data, match|
        spell_name = match[:expression]

        code = current_character.codes.find_by(name: spell_name)
        if code.try(:user).present?
          next client.web_client.chat_postMessage(
            channel: data.channel,
            text: "#{name}は既に#{code.user.name}によって記録されています。",
            username: current_character.name,
            icon_url: current_character.icon_url
          )
        end
        Code.waiting_spell(spell_name, current_user, current_character)
        post_message(
          "@#{current_user.name} 新しいコマンド、[#{spell_name}]を記録。コードを記述しSnippetとして[Command+Enter]投稿してください。"
        )
      end
    end
  end
end
