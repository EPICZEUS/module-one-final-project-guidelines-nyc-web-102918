class Console
	def help
		puts "Available commands:"
		puts "`help`            - displays this message"
		puts "`user`            - switch active user"
		puts "`add`             - adds an anime to your watched list"
		puts "`view`            - views current anime list"
		puts "`recommendations` - displays your curated recommendations"
		puts "`genre`.          - displays recommendations based on a genre"
		puts "`exit`            - exits the program"
	end

	def welcome
		puts "Welcome to the Anime Recommendation CLI!"
	end

	def input
		get.strip.downcase
	end

	def user
		puts "Please enter your name:"
		name = self.input
		puts "Please enter your age:"
		age = self,input

		@user = User.find_or_create_by(name: name, age: age.to_i)
	end

	def add
		puts "Enter anime name:"
		title = self.input
		animes = Anime.where("title LIKE ?", title)
		if animes.length > 1
			animes.each_with_index do |anime, i|
				puts "#{i + 1}. #{anime.title}"
			end
			puts "\nMultiple animes found, please specify by number:"
			selection = self.input.to_i

			anime = animes[selection - 1]
		else
			anime = animes.first
		end

		puts "Please enter your rating (1-5):"
		rating = self.input.to_i

		UserAnime.create(user_id: @user.id, anime_id: anime.id, user_rating: rating)
	end

	def view
		@user.animes.each do |anime|
			puts "Title: #{anime.title}"
			puts "My score: #{@user.user_animes.find{|uanime| uanime.anime_id == anime.id }.user_rating}"
			puts "Average rating: #{anime.score}"
			puts
		end
	end

	def recommendations
		# TODO
	end

	def genre
		# TODO
	end

	def run
		self.welcome
		self.help
		puts "Please enter command"
		user_input = nil
		until user_input == "exit"
			user_input = self.input

			if ["help", "user", "add", "view", "recommendations"].include?(input) && self.respond_to?(input)
				self.public_send(input)
			end
		end

		puts "Hope you enjoy your animes!"
	end
end