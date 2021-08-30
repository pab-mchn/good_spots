class ViewingsController < ApplicationController


  def index
    @places = Place.all
  end

  def show

  end

  def create
    place = Place.find(params[:place_id])
    liked = params[:viewing][:liked]
    Viewing.create!(place: place, liked: liked, user: current_user)
  end

  def destroy
    @place.destroy
    redirect_to 
  end

end
