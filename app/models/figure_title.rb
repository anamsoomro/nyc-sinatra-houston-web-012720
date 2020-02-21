class FigureTitle < ActiveRecord::Base
  belongs_to :figure_titles
  belongs_to :title
end
