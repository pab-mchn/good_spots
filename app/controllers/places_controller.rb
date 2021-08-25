class PlacesController < ApplicationController
  def overview
<<<<<<< HEAD
  end

  def show
=======
    @tags = Tag.all.select { |tag| tag.name.length < 8 }.sample(9)
>>>>>>> d69f7478abbd234fdbd2a711a3098a65cba1f948
  end
end
