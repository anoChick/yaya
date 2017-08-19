# frozen_string_literal: true

module YayaBot
  module Commands
    class CodeRegister < Base
      character_command '教える' do |client, data, match|
        spell_name = match[:expression]

        code = current_character.codes.find_by(name: spell_name)
        return post_message("#{spell_name}は既に#{code.user.name}によって記録されています。") if code.try(:user).present?
        Code.waiting_spell(spell_name, current_user, current_character)
        post_message("@#{current_user.name} 新しいコマンド、[#{spell_name}]を記録。コードを記述しSnippetとして投稿してください。")
      end

      character_command '忘れる' do |client, data, match|
        code = current_character.codes.find_by(name: match[:expression])
        return post_message("[#{code.name}]は登録されていません。") if code.nil?
        return post_message("[#{code.name}]はあなたに教わった魔術ではありません。") if code&.user&.id != current_user.id
        code.destroy
        post_message("[#{code.name}]はきれいさっぱり忘れました。")
      end
    end
  end
end
