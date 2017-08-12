# frozen_string_literal: true

module YayaBot
  module Commands
    class WebhookRegister < Base
      character_command 'webhook' do |client, data, match|
        webhook_name = match[:expression]
        webhook = current_character.webhooks.find_by(name: webhook_name)

        if webhook.try(:user).present?
          next client.web_client.chat_postMessage(
            channel: data.channel,
            text: "#{name}は既に#{webhook.user.name}によって記録されています。",
            username: current_character.name,
            icon_url: current_character.icon_url
          )
        end
        Webhook.waiting_spell(webhook_name, current_user, current_character)

        post_message(
          "@#{current_user.name} 新しいコマンド、[#{webhook_name}]を記録。コードを記述しSnippetとして[Command+Enter]投稿してください。"
        )
      end
    end
  end
end
