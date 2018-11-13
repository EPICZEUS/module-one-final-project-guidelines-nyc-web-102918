require_relative '../config/environment'

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

pull_anime