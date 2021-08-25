class PlacesController < ApplicationController
  def overview
    @tags = Tag.all.select { |tag| tag.name.length < 8 }.sample(9)
  end

  def show
    @place = Place.find(params[:id])
    if params[:query].present?
      # Todo -> Get all places with that query
    else
      @bottom_places = Place.all.sample(6)
    end
  end
end
