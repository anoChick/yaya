class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :slack_id, limit: 48
      t.integer :my_character_id
      t.string :name, limit: 48
      t.string :handle_name, limit: 48
      t.timestamps null: false
    end
  end
end
