module DrawScore
	#ptinr this *********************
	def decorate
		a = %{}
		(1..130).each{|i| a<< "*"}
		a
	end

	#returns a string of spaces
	def draw_space
		Proc.new{|number| "\s"*number}
	end

	#set spaces according to the size of the value
	def calculate_space value
		string = %{}
		is_array = value.is_a?(Array)
		size = is_array ? value.size : value.to_s.size
		if is_array
			size == 1 ? string << draw_space.call(7) : string << draw_space.call(3)
		else
			if size == 3
				string << draw_space.call(4)
			elsif size == 2
				string << draw_space.call(5)
			else
				string << draw_space.call(6)
			end
		end
		string
	end

	#print this Frames |1 | 2 | 3|...
	def set_frames_numbers
		string = %{\nFRAMES#{draw_space.call(8)}|}
		(1..10).each{|i| string << "#{draw_space.call(4)}#{i}#{draw_space.call(5)}|"}
		string
	end
end