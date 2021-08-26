class PlacesController < ApplicationController
  def overview
    @tags = Tag.all.select { |tag| tag.name.length < 8 }.sample(9)
  end
  
  def index

  end
end
