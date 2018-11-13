require_relative '../config/environment'

# returns an array of genre names
def get_genre_data_from_api
  response_string = RestClient.get('https://kitsu.io/api/edge/genres/')
  response_hash = JSON.parse(response_string)
  genre_objects = response_hash["data"]
  genre_objects.map {|genre| genre["attributes"]["name"]}
end

def insert_genres_into_db
  genres = get_genre_data_from_api
  genres.each do |genre|
    Genre.create(name: genre)
  end
end
