class StaticPagesController < ApplicationController

  def home
    @maps = current_user.nil? ? nil : current_user.maps
    @map = Map.new
    @map.projection = Map.projections.sample[:d3]
  end

  def about
  end

  def example
    @map = Map.find_by(example_map: true)
    render 'maps/show' if !@map.nil?
  end

  def contact
  end
end
