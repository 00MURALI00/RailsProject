class PageController < ApplicationController
  def home
    @application = Doorkeeper::Application.where
  end
end
