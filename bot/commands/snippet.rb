# frozen_string_literal: true

module YayaBot
  module Commands
    class Snippet < Base
      snippet do |client, data, _match|
        code_url = data['file']['url_private_download']

        code = current_user.codes.find_by(waiting: true) || webhooks.find_by(waiting: true)
        code.waiting = false
        code.url = code_url
        if code.class.name == 'Webhook'
          code.uid = SecureRandom.hex(16)
          code.channel = channel_id
        end
        code.save!
        message = "#{code_url} こちらのコードをWebhook[#{code.name}]として記憶しました！\nエンドポイントは'POST: #{File.join(ROOT_URL, 'webhooks', code.uid)} 'です。" if code.class.name == 'Webhook'
        message = "#{code_url} こちらのコードをコマンド[#{code.name}]として記憶しました！" if code.class.name == 'Code'
        client.web_client.chat_postMessage(
          channel: channel_id,
          text: message,
          username: current_character.name,
          icon_url: current_character.icon_url,
          unfurl_links: false
        )
      end
    end
  end
end
