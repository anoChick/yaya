# frozen_string_literal: true

module YayaBot
  module Commands
    class List < Base
      character_command 'コマンド一覧' do |client, data, match|
        message = "```\n"
        message += "コマンドは登録されていません.\n" if current_character.codes.blank?
        current_character.codes.each do |code|
          message += "#{code.name} : #{code.url}\n"
        end
        message += "```\n"
        post_message(message)
      end

      character_command 'webhook一覧' do |client, data, match|
        message = "```\n"
        message += "webhookは登録されていません.\n" if current_character.webhooks.blank?
        current_character.webhooks.each do |webhook|
          message += "#{webhook.name}( #{File.join(ROOT_URL, 'webhooks', webhook.uid)} ) : #{webhook.url}\n"
        end
        message += "```\n"
        post_message(message)
      end
    end
  end
end
