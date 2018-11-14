class UsersAnime < ActiveRecord::Base
  belongs_to :user
  belongs_to :anime
end
