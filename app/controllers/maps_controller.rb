class MapsController < ApplicationController
  before_action :logged_in_user, only: [:index, :new, :create, :edit,
                                        :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :map_permissions, only: [:show]

  def index
    @maps = current_user.maps.all
  end

  def new
    @map = Map.new
  end

  def create
    @map = current_user.maps.new(map_create_params)
    if @map.save
      flash[:info] = "Map was created! Time to add some content."
      redirect_to edit_map_path(@map)
    else
      render 'new'
    end
  end

  def edit
  end

  def show
  end

  def update
  end

  def destroy
    @map.delete
    flash[:success] = "Map deleted"
    redirect_to request.referrer || root_url
  end

  private

    def map_create_params
      params.require(:map).permit(:title, :privacy_public)
    end

    # Confirms the correct user
    def correct_user
      @map = current_user.maps.find_by(id: params[:id])
      redirect_to root_url if @map.nil?
    end

    # Setup map permissions based on @map.public
    def map_permissions
      @map = Map.find_by(id: params[:id])
      if @map.nil?
        redirect_to root_url
      elsif !@map.privacy_public
        if !logged_in?
          flash[:danger] = "Please log in."
          redirect_to login_url
        elsif current_user.maps.find_by(id: params[:id]).nil?
          redirect_to root_path
        end
      end
    end
end
