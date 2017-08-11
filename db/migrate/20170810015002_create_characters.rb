class CreateCharacters < ActiveRecord::Migration[5.1]
  def change
    create_table :characters do |t|
      t.string :name, limit: 48, null: false
      t.references :user, index: true, null: false
      t.text :icon_url
      t.timestamps
    end
  end
end
