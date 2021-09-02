class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def splash1

  end

  def splash2
  end

  def splash3
  end

  def splash4
  end
end
