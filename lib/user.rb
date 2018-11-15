class User < ActiveRecord::Base
  has_many :users_animes
  has_many :animes, through: :users_animes

  def get_recommendations_by_genre(genre_name)
    my_anime_ids = self.animes.map {|anime| anime.id}
    if self.age < 18
      recommendations = Anime
                        .joins(:genre)
                        .where("genres.name = ?
                          AND animes.age_rating IN ('G','PG')
                          AND animes.id NOT IN (?)", genre_name, my_anime_ids)
                        .order('score DESC')
                        .limit(5)
    else
      recommendations = Anime
                        .joins(:genre)
                        .where("genres.name = ?
                          AND animes.id NOT IN (?)", genre_name, my_anime_ids)
                        .order('score DESC').limit(5)
    end
    puts "Here are the top 5 animes you haven't watched in the #{genre_name} genre:"
    recommendations.each_with_index do |rec, index|
      puts "#{index + 1}. #{rec.title} - Score: #{rec.score}"
    end
  end

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
    highest_genres.each {|genre| get_recommendations_by_genre(genre)}
  end

end
