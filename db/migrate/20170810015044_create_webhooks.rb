# frozen_string_literal: true

class CreateWebhooks < ActiveRecord::Migration[5.1]
  def change
    create_table :webhooks do |t|
      t.string :name, limit: 48
      t.string :uid, limit: 255
      t.string :channel, limit: 255
      t.references :character, index: true, null: false
      t.references :user, null: false
      t.boolean :waiting
      t.boolean :private
      t.text :url
      t.timestamps
    end
  end
end
