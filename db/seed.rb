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

def pull_anime
	next_url = "https://kitsu.io/api/edge/anime"
	while next_url
		res = RestClient.get(next_url)
		data = JSON.parse(res)

		data["data"].each do |anime|
			puts anime["id"]
			attributes = anime["attributes"]
			ani = Anime.where(id: anime["id"].to_i).first
			genres = RestClient.get(anime["relationships"]["genres"]["links"]["self"])

			genre_dat = JSON.parse(genres)
			if ani.nil?
				genre_id = !genre_dat["data"].empty? ? genre_dat["data"].first["id"] : nil

			 	Anime.create(id: anime["id"].to_i,
			 		title: attributes["canonicalTitle"],
			 		age_rating: attributes["ageRating"],
			 		score: attributes["averageRating"].to_f,
			 		genre_id: genre_id)
			end
		end
		next_url = data["links"]["next"] if next_url != data["links"]["last"]
	end
end
