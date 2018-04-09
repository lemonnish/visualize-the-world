class StaticPagesController < ApplicationController

  def home
    @maps = current_user.nil? ? nil : current_user.maps
    @map = Map.new
    @map.projection = "geoNaturalEarth1"
  end

  def about
  end

  def privacy
  end

  def example
    @map = Map.find_by(example_map: true)
    render 'maps/show' if !@map.nil?
  end

  def contact
    @message = Message.new
  end

  def contact_submit
    @message = Message.new(message_params)
    if @message.valid?
      @message.send_contact_email
      flash[:info] = "Message sent!"
      redirect_to root_url
    else
      render 'contact'
    end
  end

  private

    def message_params
      params.require(:message).permit(:name, :email, :subject, :body)
    end
end
