class Yaya < SlackRubyBot::Bot
  command 'say' do |client, data, match|
    send_message client, data.channel, ENV['HEROKU_APP_NAME']
  end
end
