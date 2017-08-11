class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :slack_id, limit: 48, index: true, null: false
      t.string :name, limit: 48, null: false
      t.string :handle_name, limit: 48, null: false
      t.timestamps
    end
  end
end
