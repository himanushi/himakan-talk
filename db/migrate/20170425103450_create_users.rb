class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name_and_password, null: false
      t.string :name,              null: false
      t.string :nickname
      t.string :hash_code

      t.timestamps
    end
  end
end
