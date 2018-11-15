class Console
	def help
		puts "Available commands:"
		puts "`help`            - displays this message"
		puts "`user`            - switch active user"
		puts "`add`             - adds an anime to your watched list"
		puts "`view`            - views current anime list"
		puts "`recommendations` - displays your curated recommendations"
		puts "`genre`           - displays recommendations based on a genre"
		puts "`exit`            - exits the program"
	end

	def welcome
		puts "Welcome to the Anime Recommendation CLI!"
		puts
	end

	def input
		gets.strip.downcase
	end

	def user
		puts "Please enter your name:"
		name = self.input.capitalize

		answer = nil
		if User.all.any?{|e| e.name == name }
			loop do
				puts "Existing user found, please enter login key:"
				key = gets.strip

				@user = User.find_by(name: name, key: key)

				if @user.nil?
					puts "Incorrect login. Is this a new user? (Y/N)"
					answer = self.input

					break if answer == "y"
				else
					return
				end
			end
		end
		
		age = 0
		until age >= 13
			puts
			puts "Please enter your age:"
			age = self.input.to_i
		end

		puts
		puts "Please create login key:"
		key = gets.strip

		@user = User.find_or_create_by(name: name, age: age, key: key)
	end

	def add
		if @user.nil?
			puts "Please enter your user first!"
			return
		end

		puts "Enter anime title to search for:"
		title = self.input
		animes = Anime.where("title LIKE ?", "%#{title}%").select{|anime| !@user.animes.include?(anime) }

		if animes.empty?
			puts "No anime found by title: #{title}."
			return
		else
			animes.each_with_index do |anime, i|
				puts "#{i + 1}. #{anime.title}"
			end
			puts "\nPlease specify by number (0 to cancel):"
			selection = self.input.to_i

			return if selection == 0

			anime = animes[selection - 1]
		end

		rating = 0
		until rating.between?(1, 5)
			puts "Please enter your rating (1-5):"
			rating = self.input.to_i
		end

		UsersAnime.create(user_id: @user.id, anime_id: anime.id, user_rating: rating)
	end

	def view
		# binding.pry
		@user.animes.each do |anime|
			puts "Title: #{anime.title}"
			puts "My score: #{@user.users_animes.find{|uanime| uanime.anime_id == anime.id }.user_rating}"
			puts "Average rating: #{anime.score}"
			puts
		end
	end

	def recommendations
		if @user.nil?
			puts "Please enter your user first!"
			return
		end
		@user.get_recommendations_by_my_ratings
	end

	def genre
		genres = Genre.all.map{|g| g.name }

		genres.each{|genre| puts genre }

		puts
		puts "Enter a genre:"
		genre = self.input.capitalize

		if !genres.include?(genre)
			puts "Invalid genre"
			return
		end

		@user.get_recommendations_by_genre(genre)
	end

	def run
		self.welcome
		self.help
		
		user_input = nil
		until user_input == "exit"
			if @user
				@user = User.find(@user.id)
			end

			puts "Please enter command:"
			user_input = self.input

			# binding.pry

			if ["help", "user", "add", "view", "recommendations", "genre"].include?(user_input) && self.respond_to?(user_input)
				self.send(user_input)
			end
		end

		puts "Hope you enjoy your animes!"
	end
end