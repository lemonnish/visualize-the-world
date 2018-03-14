class MapContentsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user
  before_action :correct_map, only: [:destroy]
  before_action :define_page_variables, only: [:create, :update, :destroy]

  def create
    if params[:commit] == 'Cancel'
      redirect_to edit_map_path(@map)
    else
      @content = @map.map_contents.new(new_content_params)
      if @content.save
        flash[:info] = "Country was successfully added!"
        redirect_to edit_map_path(@map)
      else
        @new_content = @content
        @map.reload
        render 'maps/edit'
      end
    end
  end

  def update
    if params[:commit] == 'Cancel'
      redirect_to edit_map_path(@map)
    else
      input_params = update_content_params
      if input_params.empty?
        render 'maps/edit'
      elsif @map.update_content(update_content_params)
        flash.now[:success] = "Map content updated."
        redirect_to edit_map_path(@map)
      else
        render 'maps/edit'
      end
    end
  end

  def destroy
    @content.delete
    flash[:success] = "Country deleted"
    redirect_to edit_map_path(@map)
  end

  private

    def new_content_params
      params.require(:map_content).permit(:country_code, :comment)
    end

    def update_content_params
      params.require(:map_content).permit(
        @map.map_contents.map { |f| "comment_#{f.country_code}".to_sym } )
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
