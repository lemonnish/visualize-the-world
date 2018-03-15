class StaticPagesController < ApplicationController

  def home
    @maps = current_user.nil? ? nil : current_user.maps
  end

  def about
  end

  def example
    @map = Map.find_by(title: "Example Map")
    render 'maps/show' if !@map.nil?
  end

  def contact
  end
end
