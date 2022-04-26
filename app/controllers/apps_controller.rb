class AppsController < ApplicationController
  before_action :set_app, only: [:show, :update]

  def index
    @apps = App.all

    json_response(@apps.as_json(except: [:id]))
  end

  def show
    render json: @app.as_json(except: [:id])
  end

  def create

    @validation_app = App.new(app_params)
    raise ActiveRecord::RecordInvalid.new(@validation_app) if !@validation_app.valid?
    
    @app = App.create!(app_params)
    
    json_response({ token: @app.token }, :created)
    
  end

  def update
    @validation_app = App.new(app_params)
    raise ActiveRecord::RecordInvalid.new(@validation_app) if !@validation_app.valid?

    @app.update!(name: app_params[:name])

    json_response({ message: "App(" + params[:token]+ ") updated successfully." })
  end

  private
    def set_app
      @app = App.find_by!(token: params[:token])
    end

    def app_params
      params.permit(:name)
    end
end
