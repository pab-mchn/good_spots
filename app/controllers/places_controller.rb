class PlacesController < ApplicationController
  def overview
    @tags = Tag.all.select { |tag| tag.name.length < 8 }.sample(9)

    if params[:query].present?
      # Todo -> Get all places with that query
    else
      @new_places = Place.last(8)
      @more_places = Place.all.sample(18)
    end
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
