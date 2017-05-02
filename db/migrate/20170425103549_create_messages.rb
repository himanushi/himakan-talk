class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.string :content,       null: false
      t.references :user,      null: false
      t.references :chat_room, null: false

      t.timestamps
    end
  end
end
