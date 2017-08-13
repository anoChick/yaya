class CreateWatches < ActiveRecord::Migration[5.1]
  def change
    create_table :watches do |t|
      t.text :regexp_text, null: false
      t.references :character, index: true, null: false
      t.references :user, null: false
      t.boolean :waiting
      t.boolean :private
      t.text :url
      t.timestamps
    end
  end
end
