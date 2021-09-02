class ViewingsController < ApplicationController

  def index
    @viewings = Viewing.where(user:current_user).where(liked:true)
  end

  def create
    place = Place.find(params[:place_id])
    liked = params[:viewing][:liked]
    Viewing.create!(place: place, liked: liked, user: current_user)
    redirect_to viewings_path if params[:redirect]
  end

  def destroy
    @viewing = Viewing.find(params[:id])
    @viewing.destroy
    redirect_to viewings_path
  end
end
