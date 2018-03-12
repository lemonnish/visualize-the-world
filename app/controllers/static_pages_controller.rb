class StaticPagesController < ApplicationController

  def home
    @maps = current_user.nil? ? nil : current_user.maps
  end

  def about
  end

  def example
  end

  def contact
  end
end
