class MessagesController < ApplicationController
  before_action :set_chat
  before_action :set_message, only: [:show, :update]

  def index
    @messages = Message.where(chat_id: @chat.id)

    json_response(@messages.to_json(except: [:id, :chat_id]))
  end

  def show
    json_response(@message.to_json(except: [:id, :chat_id]))
  end

  def create
    @valiation_message = Message.new(chat_id: @chat.id, number: 0, content: message_params[:content]) 
    raise ActiveRecord::RecordInvalid.new(@valiation_message) if !@valiation_message.valid?

    @message_number = $redis.incr(params[:app_token] +'-chat_number-' + params[:chat_number] + '-message_number')
    
    MessageJob.perform_later(@chat.id, @message_number, message_params[:content])
    
    json_response({ number: @message_number }, :created)
    
  end

  def update
    @valiation_message = Message.new(chat_id: @chat.id, number: 0, content: message_params[:content]) 
    raise ActiveRecord::RecordInvalid.new(@valiation_message) if !@valiation_message.valid?

    @message.update!(message_params)
    
    json_response({ message: "message(#{params[:number]}) updated successfully." })

  end

  def search
    if !query_params.has_key?(:query) || query_params[:query] == nil
      json_response({ message: "parameter query is missing" })
      return
    end
    
    @query = query_params[:query]

    @messages = Message.search(@chat.id, @query)
    json_response(@messages)
  end

  private
    def set_chat
      @chat = Chat.find_by!(appToken: params[:app_token], number: params[:chat_number])
    end

    def set_message
      @message = Message.find_by!(chat_id: @chat.id, number: params[:number])
    end

    def message_params
      params.permit(:content)
    end

    def query_params
      params.permit(:query)
    end
end
