class CreateCodes < ActiveRecord::Migration
  def change
    create_table :codes do |t|
      t.string :name, limit: 48
      t.integer :user_id
      t.integer :character_id
      t.boolean :waiting
      t.boolean :private
      t.text :url
      t.timestamps null: false
    end
  end
end
