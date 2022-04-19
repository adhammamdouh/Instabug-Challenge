class ChatsController < ApplicationController
  before_action :set_app
  before_action :set_chat, only: [:show, :update, :destroy]

  # GET /chats
  def index
    @chats = Chat.all

    render json: @chats
  end

  # GET /chats/1
  def show
    render json: @chat
  end

  # POST /chats
  def create
    @chat = Chat.new(appToken: @app.token, number: 12)

    if @chat.save
      render json: @chat, status: :created
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /chats/1
  def update
    if @chat.update(chat_params)
      render json: @chat
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
  end

  # DELETE /chats/1
  def destroy
    @chat.destroy
  end

  private
    def set_app
      @app = App.find_by!(token: params[:app_id]) #TODO change to app token
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_chat
      @chat = Chat.where(appToken: params[:app_id], number: params[:id]) #TODO change to chat number
    end

    # Only allow a trusted parameter "white list" through.
    def chat_params
      params.require(:chat).permit(:number)
    end
end
