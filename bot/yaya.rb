class Yaya < SlackRubyBot::Bot
  command 'say' do |client, data, match|
    send_message client, data.channel, match['expression']
  end
end
