class CreateDelivers < ActiveRecord::Migration[5.2]
  def change
    create_table :delivers do |t|
      t.references :client, null: false, foreign_key: true
      t.string :title, null: false
      t.string :image
      t.text :body
      t.integer :count, default: 0
      t.datetime :reservation
      t.timestamps
    end
  end
end
