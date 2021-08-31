class ViewingsController < ApplicationController
  def create
    place = Place.find(params[:place_id])
    liked = params[:viewing][:liked]
    Viewing.create!(place: place, liked: liked, user: current_user)
  end
  #index for all the viewings which are liked
end
