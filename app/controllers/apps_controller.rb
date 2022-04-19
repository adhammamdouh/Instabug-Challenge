class AppsController < ApplicationController
  before_action :set_app, only: [:show]

  # GET /apps
  def index
    @apps = App.all

    json_response(@apps.as_json(except: [:id]))
  end

  # GET /apps/:token
  def show
    render json: @app.as_json(except: [:id])
  end

  # POST /apps
  def create
    # if params.presence
    @app = App.create!(app_params)
    
    json_response({ token: @app.token }, :created)
    #if @app.save
    #else
    #  render json: @app.errors, status: :unprocessable_entity
    #end
  end

  # PATCH/PUT /apps/1
  # def update
  #   if @app.update(app_params)
  #     render json: @app
  #   else
  #     render json: @app.errors, status: :unprocessable_entity
  #   end
  # end

  # DELETE /apps/1
  # def destroy
  #   @app.destroy
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app
      @app = App.find_by!(token: params[:token])
    end

    # Only allow a trusted parameter "white list" through.
    def app_params
      params.require(:app).permit(:name)
    end
end
