# frozen_string_literal: true

module YayaBot
  class Bot < SlackRubyBot::Bot
    class << self
      class_attribute :current_user, :channel_id

      def invoke(client, data)
        @channel_id = data['channel']
        @current_user = user_by_slack_id(data['user'])
        super(client, data)
      end

      def characters
        @characters || refresh_characters
      end

      def refresh_characters
        @characters = Character.all.pluck(:name, :icon_url)
      end

      def client
        instance.send(:client)
      end

      private

      def user_by_slack_id(user_id)
        user_info = client.web_client.users_info(user: user_id)['user']
        user = User.find_or_initialize_by(slack_id: user_id)
        user.update!(
          name: user_info['name'],
          handle_name: user_info['profile']['real_name']
        )

        user
      end
    end
    help do
      title 'Yayaの使い方'
      desc '各コマンドの詳細は yaya help <コマンド名> で確認することが出来ます。'
    end
  end
end
