class RemoveMessagesIndexMessagesOnChatId < ActiveRecord::Migration[5.1]
  def change
    remove_index :messages, name: "index_messages_on_chat_id"
  end
end
