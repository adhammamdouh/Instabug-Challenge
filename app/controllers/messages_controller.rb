class MessagesController < ApplicationController
  before_action :set_chat
  before_action :set_message, only: [:show, :update]

  # GET /messages
  def index
    @messages = Message.all.where(chat_id: @chat.id)

    json_response(@messages.to_json(except: [:id, :chat_id]))
  end

  # GET /messages/1
  def show
    json_response(@message.to_json(except: [:id, :chat_id]))
  end

  # POST /messages
  def create
    @valiation_message = Message.new(chat_id: @chat.id, number: 0, content: message_params[:content]) 
    raise ActiveRecord::RecordInvalid.new(@valiation_message) if !@valiation_message.valid?

    @message_number = $redis.incr(params[:app_token] +'-chat_number-' + params[:chat_number] + '-message_number')
    
    MessageJob.perform_later(@chat.id, @message_number, message_params[:content])
    
    json_response(@message_number)
    
  end

  # PATCH/PUT /messages/1
  def update
    @valiation_message = Message.new(chat_id: @chat.id, number: 0, content: message_params[:content]) 
    raise ActiveRecord::RecordInvalid.new(@valiation_message) if !@valiation_message.valid?

    @message.update!(message_params)
    
    json_response({ message: "message(" +params[:number] + ") updated successfully." })

  end

  def search
    @messages = Message.search(@chat.id, params[:query])
    json_response(@messages)
  end


  # DELETE /messages/1
  # def destroy
  #   @message.destroy
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat
      @chat = Chat.find_by!(appToken: params[:app_token], number: params[:chat_number])
    end

    def set_message
      @message = Message.find_by!(chat_id: @chat.id, number: params[:number])
    end

    def message_params
      params.require(:message).permit(:content)
    end
end
