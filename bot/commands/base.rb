# frozen_string_literal: true

module YayaBot
  module Commands
    class Base < SlackRubyBot::Commands::Base
      class << self
        class_attribute :current_character

        # Overrride SlackRubyBot::Commands::Base.invoke
        def invoke(client, data)
          finalize_routes!
          expression, text = parse(client, data)
          called = false
          if expression
            routes.each_pair do |route, options|
              match_method = options[:match_method]
              case match_method
              when :match
                match = route.match(expression)
                match ||= route.match(text) if text
                next unless match
                next if match.names.include?('bot') && !client.name?(match['bot'])
              when :character_match
                match = route.match(expression)
                match ||= route.match(text) if text
                next unless match
                next if match.names.include?('bot') && (@current_character = Character.find_by(name: match['bot'])).nil?
              when :scan
                match = expression.scan(route)
                next unless match.any?
              when :snippet_match
                next unless data['subtype'] == 'file_share' && data['file']['mode'] == 'snippet'
                code = current_user.codes.find_by(waiting: true)
                webhook = current_user.webhooks.find_by(waiting: true)
                next if code.nil? && webhook.nil?
              end
              called = true
              call = options[:call]
              if call
                call.call(client, data, match) if permitted?(client, data, match)
              elsif respond_to?(:call)
                send(:call, client, data, match) if permitted?(client, data, match)
              else
                raise NotImplementedError, data.text
              end
              break
            end
          end
          called
        end

        def character_command(*values, &block)
          values = values.map { |value| Regexp.escape(value) }.join('|')
          character_match Regexp.new("^(?<bot>[[:alnum:][:punct:]@<>]*)[\\s]+(?<command>#{values})([\\s]+(?<expression>.*)|)$", Regexp::IGNORECASE), &block
        end

        def character_match(match, &block)
          self.routes ||= ActiveSupport::OrderedHash.new
          self.routes[match] = { match_method: :character_match, call: block }
        end

        def snippet(&block)
          self.routes ||= ActiveSupport::OrderedHash.new
          self.routes[Regexp.new('//', Regexp::IGNORECASE)] = { match_method: :snippet_match, call: block }
        end

        def current_user
          YayaBot::Bot.current_user
        end

        def channel_id
          YayaBot::Bot.channel_id
        end

        def client
          YayaBot::Bot.client
        end

        def post_message(message)
          if current_character.nil?
            return client.say(channel: channel_id, text: message)
          end
          client.web_client.chat_postMessage(
            channel: channel_id,
            text: message,
            username: current_character.name || 'yaya',
            icon_url: current_character.icon_url
          )
        end
      end
    end
  end
end
