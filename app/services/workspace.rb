class Workspace
    def initialize(user, character,channel)
      @user = user
      @character = character
      @channel = channel
      @slack_client = Slack::Web::Client.new
    end

    def run(code, context)
      begin
        eval(code)
      rescue => e
        say("エラー:#{e}")
      end
    end

    def get_state(key)
      @character.character_states.find_by(key: key).try(:value)
    end

    def set_state(key, value)
      state = @character.character_states.find_or_create_by(key: key)
      state.update!(value: value) if state.present?
    end

    def say(message, channel: nil)
      @slack_client.chat_postMessage(
        channel: channel || @channel,
        text: message,
        username: @character.name,
        icon_url: @character.icon_url
      )
    end
  end
