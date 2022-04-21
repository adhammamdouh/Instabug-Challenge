class AddChatTokenAndNumberIndex < ActiveRecord::Migration[5.1]
  def change
    add_index :chats, [:appToken, :number]
  end
end
