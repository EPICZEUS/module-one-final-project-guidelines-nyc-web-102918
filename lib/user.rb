class User < ActiveRecord::Base
  has_many :users_animes
  has_many :animes, through: :users_animes

  def get_recommendations_by_genre(genre_name)
    matched_genre = Anime.all.select {|anime| anime.genre.name == genre_name}
    recommendations = matched_genre.select {|anime| anime.score > 80.0}
    if self.age < 18
      recommendations.select {|anime| anime.age_rating == 'G' || anime.age_rating == 'PG'}
    else
      recommendations
    end
  end

  def get_my_avg_genre_ratings
    my_animes = UsersAnime.all.select {|record| record.user == self}
    # iterate through my_animes to create a hash of {genre => [rating, rating, rating, etc]}
    # each iteration should check to see if the genre is already a key, if it is, push the rating,
    # if it's not, add the key and the rating
    # 
  end

  def get_recommendations_by_my_ratings
    # call get get_avg_genre_ratings
    # filter that down to any genres that have an average rating over x
    # run get_recommendations_by_genre for each of those genres
  end

end
