class Anime < ActiveRecord::Base
  has_many :users_animes
  has_many :users, through: :users_animes
  belongs_to :genre

  def self.get_recommendations_by_genre(genre_name, age = 13)
    if age < 18
      recommendations = self.joins(:genre).where("genres.name = ? AND animes.age_rating IN ('G','PG')", genre_name).order('score DESC').limit(5)
    else
      recommendations = self.joins(:genre).where("genres.name = ?", genre_name).order('score DESC').limit(5)
    end
    puts "Here are the top 5 animes in the #{genre_name} genre:"
    recommendations.each_with_index do |rec, index|
      puts "#{index + 1}. #{rec.title} - Score: #{rec.score}"
    end
  end
end
