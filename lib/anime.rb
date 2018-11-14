class Anime < ActiveRecord::Base
  has_many :users_animes
  has_many :users, through: :users_animes
  belongs_to :genre
end
