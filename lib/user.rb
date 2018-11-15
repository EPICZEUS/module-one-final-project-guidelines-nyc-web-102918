class User < ActiveRecord::Base
  has_many :users_animes
  has_many :animes, through: :users_animes

  def get_my_avg_genre_ratings
    big_decimal_avgs = UsersAnime
                       .joins(anime: :genre)
                       .where("users_animes.user_id = ?", self.id)
                       .group('genres.name')
                       .average(:user_rating)
    big_decimal_avgs.map {|genre, big_decimal| {genre => big_decimal.truncate(2).to_f}}
  end

  def get_recommendations_by_my_ratings
    avgs = self.get_my_avg_genre_ratings
    highest_avgs = avgs.select {|genre_avg| genre_avg.values[0] > 3}
    highest_genres = highest_avgs.map {|genre_avg| genre_avg.keys[0]}
    highest_genres.each {|genre| Anime.get_recommendations_by_genre(genre, self.age)}
  end
end
