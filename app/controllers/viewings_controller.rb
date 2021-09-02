class ViewingsController < ApplicationController

  def index
    @viewings = Viewing.where(user:current_user).where(liked:true)
  end

  def create
    place = Place.find(params[:place_id])
    liked = params[:viewing][:liked]
    Viewing.create!(place: place, liked: liked, user: current_user)
    respond_to do |format|
      format.html { redirect_to viewings_path }
    end
  end

  def destroy
    @viewing = Viewing.find(params[:id])
    @viewing.destroy
    redirect_to viewings_path
  end
end
