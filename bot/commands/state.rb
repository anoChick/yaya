# frozen_string_literal: true

module YayaBot
  module Commands
    class State < Base
      character_command '状態' do |client, data, match|
        state_key, state_value = match[:expression].split(' ')
        return post_message("コマンドの使い方が正しくありません.") if state_key.nil?
        state = current_character.character_states.find_or_create_by(key: state_key)
        state.update!(value: state_value) if state_value
        post_message("([#{state.key}]=> #{state.value})")
      end
    end
  end
end
