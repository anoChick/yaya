class Yaya < SlackRubyBot::Bot
    @characters = []
    @slack_client = nil
    ROOT_URL = ENV['ROOT_URL'] || '[ROOT_URL]'
    DEFAULT_CHARA_NAME = 'yaya'
    def self.characters
      @characters unless @characters.blank?

      @characters = Character.all.pluck(:name, :icon_url)
    end

    def refreshCharacters
      @characters = Character.all.pluck(:name, :icon_url)
    end

    match // do |client, data, _match|
      @slack_client = client
      # コード登録
      if data['subtype'] == 'file_share' && data['file']['mode'] == 'snippet'
        code_url = data['file']['url_private_download']
        user = User.find_by(slack_id: data['user'])
        user = User.create(slack_id: data['user'], name: client.store.users[data['user']]['name'], handle_name: client.store.users[data['user']]['real_name']) if user.nil?

        code = user.codes.find_by(waiting: true)
        webhook = user.webhooks.find_by(waiting: true)
        if code.present?
          code.waiting = false
          code.url = code_url
          code.save!
          client.web_client.chat_postMessage(
            channel: data.channel,
            text: "#{code_url} こちらのコードをコマンド[#{code.name}]として記憶しました！",
            username: code.character.name,
            icon_url: code.character.icon_url,
            unfurl_links: false
          )
        elsif webhook.present?
          webhook.waiting = false
          webhook.uid = SecureRandom.hex(16)
          webhook.url = code_url
          webhook.channel = data.channel
          webhook.save!
          client.web_client.chat_postMessage(
            channel: data.channel,
            text: "#{code_url} こちらのコードをWebhook[#{webhook.name}]として記憶しました！\nエンドポイントは'POST: #{File.join(ROOT_URL, 'webhooks', webhook.uid)} 'です。",
            username: webhook.character.name,
            icon_url: webhook.character.icon_url,
            unfurl_links: false
          )
        end
      end

      chara_name, command, *args = data['text'].split(' ')
      Character.find_or_create_by(name: DEFAULT_CHARA_NAME) if chara_name == DEFAULT_CHARA_NAME

      charas = characters.transpose[0].join('|')
      match_regexp = Regexp.new "^(#{charas})$"
      next unless chara_name.match(match_regexp)
      user = User.find_by(slack_id: data['user'])
      user = User.create(slack_id: data['user'], name: client.store.users[data['user']]['name'], handle_name: client.store.users[data['user']]['real_name']) if user.nil?

      case command

      when 'キャラ設定'
        new_chara_name, new_chara_icon_url = args
        new_chara_icon_url = new_chara_icon_url.delete('<').delete('>') if new_chara_icon_url.present?
        character = Character.find_or_create_by(name: new_chara_name)
        character.update(icon_url: new_chara_icon_url) if new_chara_icon_url.present?
        user.update(my_character_id: character.id)
        client.web_client.chat_postMessage(
          channel: data.channel,
          text: "[#{character.name}]が新しく作成されました。アイコン設定するには,[#{character.name} キャラ設定 #{character.name} [画像URL]と投稿して下さい。",
          username: character.name,
          icon_url: character.icon_url
        )
        refreshCharacters
      when 'webhook一覧'
        character = Character.find_by(name: chara_name)
        message = "```\n"
        character.webhooks.each do |webhook|
          message += "#{webhook.name}( #{File.join(ROOT_URL, 'webhooks', webhook.uid)} ) : #{code.url}\n"
        end
        message += "```\n"
        client.web_client.chat_postMessage(
          channel: data.channel,
          text: message,
          username: character.name,
          icon_url: character.icon_url,
          unfurl_links: false
        )
      when 'コマンド一覧'
        character = Character.find_by(name: chara_name)
        message = "```\n"
        character.codes.each do |code|
          message += "#{code.name} : #{code.url}\n"
        end
        message += "```\n"
        client.web_client.chat_postMessage(
          channel: data.channel,
          text: message,
          username: character.name,
          icon_url: character.icon_url,
          unfurl_links: false
        )
      when 'webhook'
        name = args[0]
        character = Character.find_by(name: chara_name)
        webhook = character.webhooks.find_by(name: name)
        if webhook.try(:user).present?
          next client.web_client.chat_postMessage(
            channel: data.channel,
            text: "#{name}は既に#{webhook.user.name}によって記録されています。",
            username: character.name,
            icon_url: character.icon_url
          )
        end

        Webhook.waiting_spell(name, user, character)

        client.web_client.chat_postMessage(
          channel: data.channel,
          text: "@#{user.name} 新しいWebhook、[#{name}]を記録。コードを記述しSnippetとして[Command+Enter]投稿してください。",
          username: character.name,
          icon_url: character.icon_url
        )

      when '教える'
        name = args[0]
        character = Character.find_by(name: chara_name)
        code = character.codes.find_by(name: name)
        if code.try(:user).present?
          next client.web_client.chat_postMessage(
            channel: data.channel,
            text: "#{name}は既に#{code.user.name}によって記録されています。",
            username: character.name,
            icon_url: character.icon_url
          )
        end
        Code.waiting_spell(name, user, character)

        client.web_client.chat_postMessage(
          channel: data.channel,
          text: "@#{user.name} 新しいコマンド、[#{name}]を記録。コードを記述しSnippetとして[Command+Enter]投稿してください。",
          username: character.name,
          icon_url: character.icon_url
        )
      when '状態'
        state_key = args[0]
        state_value = args[1]
        next if state_key.nil?
        character = Character.find_by(name: chara_name)
        state = character.character_states.find_or_create_by(key: state_key)
        state.update!(value: state_value) if state_value
        client.web_client.chat_postMessage(
          channel: data.channel,
          text: "([#{state.key}]=> #{state.value})",
          username: character.name,
          icon_url: character.icon_url
        )

      when '忘れる'
        name = args[0]
        character = Character.find_by(name: chara_name)
        code = character.codes.find_by(name: name)

        if code.nil?
          next client.web_client.chat_postMessage(
            channel: data.channel,
            text: "[#{name}]は登録されていません。",
            username: character.name,
            icon_url: character.icon_url
          )
        end

        if code.try(:user).try(:id) != user.id
          next client.web_client.chat_postMessage(
            channel: data.channel,
            text: "#{name}はあなたに教わった魔術ではありません。",
            username: character.name,
            icon_url: character.icon_url
          )
        end
        code.destroy
        client.web_client.chat_postMessage(
          channel: data.channel,
          text: "[#{name}]はきれいさっぱり忘れました。",
          username: character.name,
          icon_url: character.icon_url
        )

      else
        next unless command =~ /(!|！)$/
        command = command.delete('！').delete('!')
        character = Character.find_by(name: chara_name)
        code = character.codes.find_by(name: command)
        if code.nil?
          next client.web_client.chat_postMessage(
            channel: data.channel,
            text: "[#{command}は記録されていません。]",
            username: character.name,
            icon_url: character.icon_url
          )
        end
        ExecCommandJob.perform_later(command, data.to_json)
      end
    end
  end
