require_relative '../config/environment'

ActiveRecord::Base.logger = nil

Console.new.run

puts "HELLO WORLD"
