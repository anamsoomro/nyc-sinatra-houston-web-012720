class Figure < ActiveRecord::Base
  has_many :figure_titles
  has_many :landmarks
  has_many :titles, through: :figure_titles
end
