module FileCreator
	def create_file name, content=""
		File.open("test_bowling.txt", "w") do |f|     
		  f.write(content)   
		end
	end

	def delete_file name
		File.delete(name)
	end

	def create_directory name
		Dir.mkdir(name)
	end

	def delete_directory name
		Dir.delete(name)
	end
end