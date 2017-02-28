class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.string :name, limit: 48
      t.string :user_id
      t.text :icon_url
      t.timestamps null: false
    end
  end
end
