class ContentFile
	class << self
		#returns an array of the content found in the file txt
		# ["Jeff 10", "John 4", "John 5","Jeff F"...]
		def convert_content_in_array content
			return nil if content.nil? || content == ""
			my_content_array = []
			content.gsub!(/\r\n/, "\n")
			content.each_line{|line| my_content_array << line}
			raise "The content is too short to start the Bowling score. 
			Please fill the file with at least 24 valid lines" if my_content_array.count < 24
			my_content_array
		end

		#returns a hash with the players as a key
		#{"Jeff" => [10,"F"], "John"=>[4, 5]}
		def convert_content_in_hash my_array 
			records = {}
			my_array.each_with_index do |element,line|
				split_element = element.split(" ")
				raise "The content of the line #{line} is invalid #{element} please set the name of the player and the score" if split_element.size < 2
				records[split_element.first] ||= []
				records[split_element.first] << define_class(split_element.last)
			end if !my_array.empty?
			records
		end

		#the program will accept just character F otherwise the score must be an integer
		def is_a_valid_character value
			raise "this value #{value} is invalid for the score " if value.to_s.downcase != "f"
			value
		end

		def define_class value
			value.to_i.to_s == value.to_s ? value.to_i : is_a_valid_character(value)
		end
	end
end