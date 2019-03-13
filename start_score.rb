require_relative "bowling.rb"
class StartScore

	DIRECTORY = "games" #older that contains the games.txt

	#array with all the files found into the directory "games"
	def self.get_files
		FileTxt.get_all_txt_files(DIRECTORY)
	end

	def self.draw_final_score
		game_files = get_files
		if game_files.empty?
			puts "There were not files found in the folder #{DIRECTORY}"
		else
			puts "**************** Bowling game scores ******************\n"
			game_files.each do |game_file|
				puts "********Reading scores in #{game_file}**********\n"
				bowling = Bowling.new() #initiate class
				bowling.get_file(game_file) #set content file into a hash 
				puts bowling.print_score #print the score
				puts bowling.set_winner #print the table of positions
				puts "********END #{game_file}**********\n\n\n"
			end
		end
	end
end

StartScore.draw_final_score