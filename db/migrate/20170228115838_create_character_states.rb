class CreateCharacterStates < ActiveRecord::Migration
  def change
    create_table :character_states do |t|
      t.integer :character_id
      t.string :key, limit: 255
      t.text :value
      t.timestamps null: false
    end
  end
end
