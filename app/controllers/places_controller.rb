class PlacesController < ApplicationController
  def overview
    specified_tag_names = [:Coffee, :Grocerie, :Social, :Company, :Eatery, :Shopping]
    @specified_tags =  specified_tag_names.map do |name|
      Tag.find_by_name(name)
    end

    @tags = Tag.all.select { |tag| tag.name.length < 8 }.sample(9)
    if params[:query].present?
      # Todo -> Get all places with that query
    else
      @new_places = Place.last(8)
      @more_places = Place.all.sample(18)
    end
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

  def swipe
    if params[:search_term].present?
      @places = Place.search_by_name_and_description(params[:search_term])
      @swipe_places = Place.all.sample(6)
    else
      @swipe_places = Place.all.sample(6)
    end
  end
end
