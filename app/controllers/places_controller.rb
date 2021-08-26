class PlacesController < ApplicationController
  def overview
    @tags = Tag.all.select { |tag| tag.name.length < 8 }.sample(9)
  end

  def tag_image
    @tag_image
    # if available > show the image from ou API
    # else get a random image from unsplash - with topic = xxx
  end
end
