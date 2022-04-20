class MessageJob < ApplicationJob
  queue_as :default

  def perform(chat_id, message_number)

    @message = Message.new(chat_id: chat_id, number: message_number)
    @message.save!

  end
end
