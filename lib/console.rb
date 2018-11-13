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
end