class CreateChats < ActiveRecord::Migration[5.1]
  def change
    create_table :chats do |t|
      t.references :appToken, foreign_key: true
      t.integer :number
      t.integer :messageCount

      t.timestamps
    end
  end
end
