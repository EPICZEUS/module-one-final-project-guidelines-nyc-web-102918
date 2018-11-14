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
    ratings = {}
    # iterate through my_animes to create a hash of {genre => [rating, rating, rating, etc]}
    # each iteration should check to see if the genre is already a key, if it is, push the rating,
    # if it's not, add the key and the rating
    my_animes.each do |record|
      if ratings.keys.include?(record["genre_id"])
        ratings[record["genre_id"]] << record["rating"]
      else
        ratings[record["genre_id"]] = []
        ratings[record["genre_id"]] << record["rating"]
      end
    end
    # iterate through the hash using map and add the ratings and divide by the length of the value array
    ratings.map do |genre_id, ratings|
      sum = ratings.inject {|sum, rating| sum + rating}
      avg = sum / ratings.length
      {genre_id => avg}
    end
  end

  def get_recommendations_by_my_ratings
    # call get_avg_genre_ratings
    avgs = get_avg_genre_ratings
    # filter that down to any genres that have an average rating over x
    avgs.select {|avg|}
    # run get_recommendations_by_genre for each of those genres
  end

end
