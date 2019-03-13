class FileTxt
	class << self
		#returns true if the file exists
		def file_exist? file_name
			File.exist?(file_name)
		end

		#read the file and will avoid all empty lines
		def open_file file_name
			return nil if !file_exist?(file_name)
			File.readlines(file_name).reject { |s| s.strip.empty? }.join
		end

		#returns true if the directory exists
		def directory_exists?(directory)
		  File.directory?(directory)
		end

		#return an array with all the files into the directory
		def get_all_txt_files directory
			return [] if !directory_exists?(directory)
			Dir["#{directory}/*.txt"]
		end
	end
end