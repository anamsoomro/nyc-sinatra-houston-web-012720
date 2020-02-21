class FiguresController < ApplicationController
  set :views, "app/views/figures"
  # set :method_override, true

  get "/figures" do 
    @figures = Figure.all 
    erb :index
  end

  get "/figures/new" do 
    @titles = Title.all
    @landmarks = Landmark.where(figure_id: nil)
    erb :new
  end

  post "/figures" do
    if params[:figure][:name] != ""
      new_fig=Figure.create(name: params[:figure][:name])
      if params[:title][:name] != ""
        title = Title.create(name: params[:title][:name])
        FigureTitle.create(title_id: title.id, figure_id: new_fig.id)
      end
      if params[:title][:title_id]
        params[:title][:title_id].each do |title_id|
          FigureTitle.create(title_id: title_id, figure_id: new_fig.id)
        end
      end
      if params[:landmark][:landmark_id]
        params[:landmark][:landmark_id].each do |landmark_id|
          landmark = Landmark.find(landmark_id)
          landmark.update(figure_id: new_fig.id)
        end
      end
      if params[:landmark][:name] != "" && params[:landmark][:year] != ""
        Landmark.create(name: params[:landmark][:name], year_completed: params[:landmark][:year], figure_id: new_fig.id)
      end
      redirect "/figures/#{new_fig.id}"
    else
      redirect "/figures"
    end

  end

  get "/figures/:id" do
    @figure = current_figure
    erb :show
  end

  get '/figures/:id/edit' do 
    @figure = current_figure
    @titles = Title.all
    @landmarks = Landmark.where(figure_id: nil)
    erb :edit
  end

  patch '/figures/:id' do 
    @figure = current_figure
    @figure.update(name: params[:figure][:name])
    @figure.landmarks.pluck(:id).each do |id|
      landmark = Landmark.find(id)
      landmark.update(figure_id: nil)
    end
    @figure.figure_titles.destroy_all
    # if user selected existing titles, connect figures and titles
    if params[:title][:title_id]
      params[:title][:title_id].each do |title_id|
        # create a title only if it doesnt exist 
        if !@figure.titles.pluck(:id).include? (title_id.to_i)
          FigureTitle.create(title_id: title_id, figure_id: @figure.id)
        end
      end
    end
    # if user creates new titles, create new title and link to figure
    if params[:title][:name] != ""
      title = Title.create(name: params[:title][:name])
      FigureTitle.create(title_id: title.id, figure_id: @figure.id)
    end
    # if user selects existing landmarks, find each landmark and update the figure id
    if params[:landmark][:landmark_id]
      params[:landmark][:landmark_id].each do |landmark_id|
        landmark = Landmark.find(landmark_id)
        landmark.update(figure_id: @figure.id)
      end
    end
    # if user creates a new landmark, create that landmark with the figure id 
    if params[:landmark][:name] != "" && params[:landmark][:year] != ""
      Landmark.create(name: params[:landmark][:name], year_completed: params[:landmark][:year], figure_id: @figure.id)
    end
    redirect "/figures/#{@figure.id}"
  end

  delete "/figures/:id" do 
    @figure = current_figure
    @figure.landmarks.each do |landmark| 
      landmark.update(figure_id: nil)
    end
    @figure.figure_titles.destroy_all 
    @figure.destroy
    redirect "/figures"
  end


  def current_figure
    Figure.find(params[:id])
  end


end
