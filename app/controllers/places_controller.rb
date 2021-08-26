class PlacesController < ApplicationController
  def overview
    @tags = Tag.all.select { |tag| tag.name.length < 8 }.sample(9)
    @recommended_places = Place.where(recommended: true).sample(15)
  end

  def show
    @place = Place.find(params[:id])
    if params[:query].present?
      # Todo -> Get all places with that query
    else
      @bottom_places = Place.all.sample(6)
    end
  end

  def index

  end
end
