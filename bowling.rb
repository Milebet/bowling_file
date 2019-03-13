require_relative "file_txt.rb"
require_relative "modules/draw_score.rb"
require_relative "content_file.rb"

#This class will take the scores in the file and print the screen
class Bowling

	include DrawScore
	
	MAX_FRAMES = 12
	FINAL_FRAME = 10
	MAX_SCORE = 10
	MAX_TURNS_PER_FRAME = 2
	SYMBOLS = {
		strike: "x",
		spare: "/"
	}

	# class methods
	class << self

		#returns true if the character is equal to F which means Fault
		def is_a_fault? value
			value.is_a?(String) && value.downcase == "f"
		end

		#returns true if the score into a frame was a strike (10 knocked down pins)
		def is_a_strike? value
			if value.is_a?(Array)
				value.size == 1 && value.first == MAX_SCORE ? true : false
			else
				return false if is_a_fault?(value)
				value == MAX_SCORE
			end
		end

		#returns the sum of the elements into an array
		def sum_elements array_element
			array_element.inject(:+) rescue 0
		end

		#verifies if in the scores of a frame were faults commited
		def are_there_faults? array_element
			faults = array_element.select{|e| e.to_s.downcase == "f"}
			faults.empty? ? false : true
		end

		#returns true if the sum of the scores into a frame were equal to 10 (spare)
		def is_a_spare? array_element
			array_element.size == 2 && !are_there_faults?(array_element) && 
			sum_elements(array_element) == MAX_SCORE
		end

		#returns the sum of the knoed down pins into a frame
		def calculate_knocked_down_pins array_element
			total_pins_down = 0
			array_elem = array_element.dup
			if !are_there_faults?(array_elem)
				total_pins_down += sum_elements(array_elem)
			else
				result = array_elem.reject{|e| is_a_fault?(e)}
				total_pins_down += sum_elements(result) if !result.empty?
			end if !array_elem.empty?
			total_pins_down
		end

		#verifies if the values of the scores are numbers or an F for fault
		def is_a_valid_value? value
			return false if value.is_a?(String) && !is_a_fault?(value)
			is_a_fault?(value) || value >= 0 && value <= MAX_SCORE
		end
	end

	######################## Instance methods #################################
	#set the variables with the content of the players
	def get_file file_name
		begin
			game_file ||= FileTxt.open_file(file_name)
			raise "No file found" if game_file.nil?
			array_content ||= ContentFile.convert_content_in_array(game_file)
			@players = ContentFile.convert_content_in_hash(array_content)
			raise "No scores were found in the file #{file_name}" if @players == {}
			@official_scores = {}
		rescue Exception => e
			puts e
		end
	end

	#returns an array with the players their pinfalls
	#{"player1" => {pins: [9,1]}}
	def order_down_pins_per_frame
		begin
			raise "There is nothing to score" if @players == {}
			@players.each do |player,down_pins|
				@official_scores[player] ||= {}
				(1..down_pins.size).each do |index|
					#break if index > MAX_FRAMES
					frame = organize_knocked_down_pins(down_pins)
					last_frame = @official_scores[player][FINAL_FRAME][:pins] rescue nil
					#this for the cases were are extra turns due to spare or strike in the 10th frame
					if is_an_aditional_frame?(last_frame)
						@official_scores[player][:add] ||= {}
						@official_scores[player][:add][:pins] ||= []
						if Bowling.is_a_strike?(last_frame)
							@official_scores[player][:add][:pins] << frame if @official_scores[player][:add][:pins].size < 2
							@official_scores[player][:add][:pins].flatten!
						elsif Bowling.is_a_spare?(last_frame)
							@official_scores[player][:add][:pins] << frame.first if @official_scores[player][:add][:pins].size < 1
							@official_scores[player][:add][:pins].flatten!
						else
							puts "Player #{player} did not have chances for an extra turn because he did not make any strike or spare in the 10th frame"
						end if !frame.empty?
					else
						@official_scores[player][index] = {}
						@official_scores[player][index][:pins] = frame
						raise "#{frame} the numbers of pins knoked down in the frame #{index} are invalid, there are more than 10." if !valid_frame_score?(frame,index)
					end
				end
			end
		rescue Exception => e
			puts e
		end
	end

	#update the hash of players with their scores per frame
	#{"player1" => {pins: [9,1], total: 10}}
	def set_scores_per_frame
		begin
			order_down_pins_per_frame
			raise "Nothing to score" if @official_scores == {}
			@official_scores.each do |player,frames|
				total_score = 0
				frames.each do |index_frame, results|
					if index_frame != :add
						@official_scores[player][index_frame][:score] = calculate_points_per_frame(player,index_frame)
						total_score += @official_scores[player][index_frame][:score]
						@official_scores[player][index_frame][:total] = total_score
					end
				end
			end
		rescue Exception => e 
			puts e
		end
	end

	#returns false if the sum of the two turns in a frame is more than 10
	def valid_frame_score? array_score, index_frame
		return false if array_score.empty?
		index_frame > 10 ? true : Bowling.calculate_knocked_down_pins(array_score) <= MAX_SCORE 
	end

	#takes an array of elments and organize them according to the size of a frame
	#[2,5,'f',5] => [2,5] ['f',5]
	def organize_knocked_down_pins pins_down,array_score = []
		begin
			return [] if pins_down.empty?
			score = pins_down.shift
			raise "#{score} is not a valid value" if !Bowling.is_a_valid_value?(score)
			array_score << score
			organize_knocked_down_pins(pins_down, array_score) if !Bowling.is_a_strike?(score) && array_score.size < MAX_TURNS_PER_FRAME
			array_score
		rescue Exception => e
			puts e.message
		end
	end

	def is_an_aditional_frame? last_frame
		!last_frame.nil? && 
		(last_frame.size == MAX_TURNS_PER_FRAME || Bowling.is_a_strike?(last_frame))
	end

	#returns the scores of the frame
	def get_frame player, index 
		@official_scores[player][index][:pins].dup
	end

	#returns the sum of the total of scores per frame
	#analizing if there were strikes o spares
	def calculate_points_per_frame my_player, index_frame
		frame = get_frame(my_player,index_frame)
		total_pins_down = Bowling.calculate_knocked_down_pins(frame)
		score = 0
		is_strike = Proc.new do |value|
			if Bowling.is_a_strike?(value)
				score += MAX_SCORE
				true
			else
				false
			end
		end
		if total_pins_down == MAX_SCORE && index_frame != :add
			if is_strike.call(frame)
				if index_frame == MAX_SCORE #if is the frame 10.. take the additionals two turns
					frame_2 = get_frame(my_player,:add)
					score += Bowling.calculate_knocked_down_pins(frame_2)
				else
					frame_2 = get_frame(my_player,index_frame + 1)
					if is_strike.call(frame_2)
						index = index_frame == 9 ? :add : index_frame + 2
						frame_3 = get_frame(my_player,index)
						if !is_strike.call(frame_3)
							score += Bowling.is_a_fault?(frame_3.first) ? 0 : frame_3.first
						end
					else
						score +=  Bowling.calculate_knocked_down_pins(frame_2)
					end
				end
			else #spare
				score += MAX_SCORE
				index = index_frame == MAX_SCORE ? :add : index_frame + 1
				frame = get_frame(my_player,index)
				score += Bowling.is_a_fault?(frame.first) ? 0 : frame.first
			end
		else
			score += total_pins_down
		end
		score
	end

	#call the methods to set the correct score per frame and returns a screen of the results
	def print_score
		begin
			set_scores_per_frame
			raise "There is nothing to print" if @official_scores.nil?
			screen = %{}
			screen << decorate
			screen << set_frames_numbers #print frames from 1 to 10
			@official_scores.each do |player,frames|
				screen << "\n#{player}\nPinfalls#{draw_space.call(6)}|"
				frames.each do |index_frame,results|
					pins = results[:pins]
					screen << calculate_space(pins)
					if pins.size == 1 && pins.first == MAX_SCORE
						screen << "#{SYMBOLS[:strike]}"
					elsif Bowling.calculate_knocked_down_pins(pins) == MAX_SCORE
						screen << "#{pins.first}\s|\s#{SYMBOLS[:spare]}"
					elsif pins.size == MAX_TURNS_PER_FRAME
						screen << "#{pins.first}\s|\s#{pins.last}"
					else
						screen << "#{pins.first}"
					end
					screen << "#{draw_space.call(2)}|"
				end
				screen << "\nScore#{draw_space.call(9)}|"
				frames.each do |index_frame,results|
					total = results[:total]
					screen << calculate_space(total)
					screen <<  "#{total}#{draw_space.call(3)}|"
				end
				screen << "\n"
			end
			screen << decorate
			screen
		rescue Exception => e
			puts e
		end
	end

	#show the results according to the final score
	def set_winner
		begin
			raise "There is nothing to print" if @official_scores.nil?
			scores = []
			@official_scores.each do |player,frames|
				scores << {player => frames[FINAL_FRAME][:total]}
			end
			scores.sort_by!{|player| player[player.keys.first]}
			string =  %{*******Positions********\n}
			scores.reverse.each do |player|
				string << "*     #{player.keys.first} = #{player[player.keys.first]}       *\n"
			end
			string << "******** end ***********\n"
		rescue Exception => e
			puts e
		end
	end
end
