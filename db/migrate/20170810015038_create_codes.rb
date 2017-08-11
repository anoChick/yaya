class CreateCodes < ActiveRecord::Migration[5.1]
  def change
    create_table :codes do |t|
      t.string :name, limit: 48, null: false
      t.references :character, index: true, null: false
      t.references :user, null: false
      t.boolean :waiting
      t.boolean :private
      t.text :url
      t.timestamps
    end
  end
end
