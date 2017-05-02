class CreateChatRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :chat_rooms do |t|
      t.string  :url,     null: false
      t.integer :owner_id, null: false

      t.timestamps
    end
    add_foreign_key :chat_rooms, :users, column: :owner_id
  end
end
