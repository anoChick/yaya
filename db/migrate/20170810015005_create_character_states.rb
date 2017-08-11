# frozen_string_literal: true

class CreateCharacterStates < ActiveRecord::Migration[5.1]
  def change
    create_table :character_states do |t|
      t.references :character, index: true, null: false
      t.string :key, limit: 255
      t.text :value
      t.timestamps
    end
  end
end
