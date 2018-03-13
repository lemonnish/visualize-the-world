class MapContentsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user

  def create
  end

  def update
  end

  def destroy
    @content.delete
    flash[:success] = "Country deleted"
    redirect_to request.referrer || root_url
  end

  private

    # Confirms the user matches the map owner
    def correct_user
      @map = current_user.maps.find_by(id: params[:map_id])
      if @map.nil?
        redirect_to root_url
      else
        @content = @map.map_contents.find_by(id: params[:id])
        redirect_to request.referrer || map_path(@map) if @content.nil?
      end
    end
end
