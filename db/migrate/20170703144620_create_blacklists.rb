class CreateBlacklists < ActiveRecord::Migration[5.0]
  def change
    create_table :blacklists do |t|
      t.string  :word, null: false

      t.timestamps
    end
    add_index :blacklists, :word, unique: true
  end
end
