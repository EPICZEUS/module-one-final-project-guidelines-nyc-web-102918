require_relative '../config/environment'

def get_genre_data_from_api
  url = 'https://kitsu.io/api/edge/genres/'
  genre_objects = []
  while url
    response_string = RestClient.get(url)
    response_hash = JSON.parse(response_string)
    genre_objects << response_hash["data"]
    url = response_hash["links"]["next"]
  end
  genre_objects.flatten.map {|genre| {"id" => genre["id"], "name" => genre["attributes"]["name"]}}
end

def insert_genres_into_db
  genres = get_genre_data_from_api
  existing_genre_names = Genre.all.map {|genre| genre.name}
  genres.each do |genre|
    if !existing_genre_names.include?(genre["name"])
      Genre.create(genre)
    end
  end
end
