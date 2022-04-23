class ChatsController < ApplicationController
  before_action :set_app, only: [:create]
  before_action :set_chat, only: [:show]

  # GET /chats
  def index
    @chats = Chat.all.where(appToken: params[:app_token])

    json_response(@chats.to_json(except: [:id]))
  end

  # GET /chats/1
  def show
    json_response(@chat.to_json(except: [:id]))
  end

  # POST /chats
  def create
    @validation_chat = Chat.new(appToken: params[:app_token], number: 0)
    raise ActiveRecord::RecordInvalid.new(@validation_chat) if !@validation_chat.valid?

    @chat_number = $redis.incr(params[:app_token] +'-chat_number')
    
    ChatJob.perform_later(params[:app_token], @chat_number)
    
    json_response({ number: @chat_number })
  end

  private
    def set_app
      @app = App.find_by!(token: params[:app_token])
    end

    def set_chat
      @chat = Chat.find_by!(appToken: params[:app_token], number: params[:number])
    end

end
