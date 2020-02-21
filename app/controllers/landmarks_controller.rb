class LandmarksController < ApplicationController
  set :views, "app/views/landmarks"
  # set :method_override, true

  get "/landmarks" do 
    @landmarks = Landmark.all 
    erb :index
  end

  # get "/landmarks/:id" do
  #   @landmark = current_landmark
  #   erb :show
  # end

  get "/landmarks/:id/edit" do
    @landmark = current_landmark
    erb :edit
  end

  def current_landmark 
    Landmark.find(params[:id])
  end

end
