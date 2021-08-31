class ViewingsController < ApplicationController

  def index
    @places = Place.all.first(6)
  end

  def create
    place = Place.find(params[:place_id])
    liked = params[:viewing][:liked]
    Viewing.create!(place: place, liked: liked, user: current_user)
  end

  def destroy
    @place.destroy
    redirect_to place_viewings_path
  end

end
