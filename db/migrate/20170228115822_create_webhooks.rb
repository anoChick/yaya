class CreateWebhooks < ActiveRecord::Migration
  def change
    create_table :webhooks do |t|
      t.string :name, limit: 48
      t.string :uid, limit: 255
      t.string :channel, limit: 255
      t.integer :character_id
      t.integer :user_id
      t.boolean :waiting
      t.boolean :private
      t.text :url
      t.timestamps null: false
    end
  end
end
