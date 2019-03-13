require_relative "../content_file.rb"
require_relative "../modules/file_creator.rb"
require "test/unit"

class TestContentFile < Test::Unit::TestCase
	include FileCreator

	def create_content
		Proc.new{|num| "Joe\s10\n" * num}
	end

	def test_if_returns_nil_when_not_content
		content = nil 
		assert_nil ContentFile.convert_content_in_array(content)
		content = create_content.call(24)
		assert_not_nil ContentFile.convert_content_in_array(content)
	end

	def test_if_error_when_content_is_incomplete
		content = create_content.call(10)
		assert_raise do
			ContentFile.convert_content_in_array(content)
		end
	end


	def test_return_empty_if_array_is_blank
		my_array = []
		assert_equal ContentFile.convert_content_in_hash(my_array), {}
	end

	def test_error_if_the_file_is_too_short
		my_array = create_content.call(3).split("\n")
		my_array << "Test"
		assert_raise do 
			ContentFile.convert_content_in_hash(my_array)
		end
	end

	def test_if_returns_correct_hash
		my_array = create_content.call(24).split("\n")
		my_hash = ContentFile.convert_content_in_hash(my_array)
		assert_equal my_hash.class.to_s, "Hash"
		assert_equal my_array.count,24
	end

	def test_raise_if_invalid_character
		my_array = create_content.call(3).split("\n")
		my_array << "Test abc"
		assert_raise do 
			ContentFile.convert_content_in_hash(my_array)
		end
	end
end