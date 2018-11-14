class Console
	def help
		puts "Available commands:"
		puts "`help`            - displays this message"
		puts "`user`            - switch active user"
		puts "`add`             - adds an anime to your watched list"
		puts "`view`            - views current anime list"
		puts "`recommendations` - displays your curated recommendations"
		puts "`exit`            - exits the program"
	end

	def welcome
		puts "Welcome to the Anime Recommendation CLI!"
	end

	def input
		get.strip.downcase
	end

	def user
		
	end

	def add
		
	end

	def view
		
	end

	def recommendations
		
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