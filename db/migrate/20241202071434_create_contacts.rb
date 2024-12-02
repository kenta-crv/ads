class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :tel
      t.string :email
      t.string :messages
      t.timestamps
    end
  end
end
