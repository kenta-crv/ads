class CreateSubscribers < ActiveRecord::Migration[5.2]
  def change
    create_table :subscribers do |t|
      t.text :endpoint
      t.text :p256dh
      t.text :auth
      t.string :browser
      t.string :user_agent

      t.timestamps
    end
  end
end
