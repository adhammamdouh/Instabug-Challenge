class AppsController < ApplicationController
  before_action :set_app, only: [:show, :update]

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

    @validation_app = App.new(app_params)
    raise ActiveRecord::RecordInvalid.new(@validation_app) if !@validation_app.valid?
    
    @app = App.create!(app_params)
    
    json_response({ token: @app.token }, :created)
    
  end

  # PATCH/PUT /apps/1
  def update
    @validation_app = App.new(app_params)
    raise ActiveRecord::RecordInvalid.new(@validation_app) if !@validation_app.valid?

    @app.update!(name: app_params[:name])

    json_response({ message: "App(" + params[:token]+ ") update successfully." })
  end

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
