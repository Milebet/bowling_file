require_relative "../file_txt.rb"
require_relative "../modules/file_creator.rb"
require 'test/unit'

class TestFileTxt < Test::Unit::TestCase

	include FileCreator

	def test_if_a_directory_exsits
		create_directory('test_game')
		assert FileTxt.directory_exists?("test_game")
		delete_directory('test_game')
		assert_not_equal FileTxt.directory_exists?("test_game"), true
	end

	def test_if_a_file_exists
		create_file("test_bowling.txt")
		assert FileTxt.file_exist?("test_bowling.txt")
		delete_file("test_bowling.txt")
		assert_not_equal FileTxt.file_exist?("test_bowling.txt"), true
	end

	def test_if_file_opens_correctly
		create_file("test_bowling.txt","a\nb\n\n\n")
		content = FileTxt.open_file("test_bowling.txt")
		assert_not_nil content
		#should return the content without empty lines
		assert_equal content, "a\nb\n"
		delete_file("test_bowling.txt")
	end

	def test_if_directory_returns_files
		create_directory("test_game") if !FileTxt.directory_exists?("test_game")
		(1..5).each do |i|
			create_file("test_game/test_game#{i}.txt")
		end
		files = FileTxt.get_all_txt_files("test_game")
		assert_not_nil files
		files.each_with_index do |file,index|
			assert_equal file, "test_game_#{index}.txt"
		end
		delete_directory("test_game")
	end
end