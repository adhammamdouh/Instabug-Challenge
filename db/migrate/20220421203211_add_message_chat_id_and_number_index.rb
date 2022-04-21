class AddMessageChatIdAndNumberIndex < ActiveRecord::Migration[5.1]
  def change
    add_index :messages, [:chat_id, :number]
  end
end
