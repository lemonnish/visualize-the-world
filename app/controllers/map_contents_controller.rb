class MapContentsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user
  before_action :correct_map, only: [:update, :destroy]
  before_action :define_page_variables, only: [:update, :destroy]

  def create
    if params[:map_content][:commit] == 'Cancel'
      redirect_to edit_map_path(@map)
    else
      @content = @map.map_contents.new(new_content_params)
      if @content.save
        flash[:info] = "Country was successfully added!"
        redirect_to edit_map_path(@map)
      else
        @new_content = @content
        render 'maps/edit'
      end
    end
  end

  def update
    if params[:map_content][:commit] == 'Cancel'
      redirect_to edit_map_path(@map)
    elsif @content.update_attributes(update_content_params)
      flash.now[:success] = "Map content updated."
      redirect_to edit_map_path(@map)
    else
      render 'maps/edit'
    end
  end

  def destroy
    @content.delete
    flash[:success] = "Country deleted"
    redirect_to request.referrer || root_url
  end

  private

    def new_content_params
      params.require(:map_content).permit(:country_code, :comment)
    end

    def update_content_params
      params.require(:map_content).permit(:comment)
    end

    def define_page_variables
      @new_content = MapContent.new
    end

    # Confirms the user matches the map owner
    def correct_user
      @map = current_user.maps.find_by(id: params[:map_id])
      redirect_to root_url if @map.nil?
    end

    # Confirms the map content belongs to the map
    def correct_map
      @content = @map.map_contents.find_by(id: params[:id])
      redirect_to maps_path if @content.nil?
    end
end
