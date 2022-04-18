class AddReferenceOnAppTokenToChats < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :chats, :apps, column: :appToken, primary_key: "token"
  end
end
