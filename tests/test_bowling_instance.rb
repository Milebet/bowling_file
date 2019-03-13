require_relative "../bowling.rb"
require_relative "../modules/file_creator.rb"
require 'test/unit'

class TestBowlingInstance < Test::Unit::TestCase
	include FileCreator
	
	def setup
		@bowling = Bowling.new
	end

	def test_bowling_instance_class_is_not_nil
    	assert_not_nil @bowling
    end

    def test_if_is_a_valid_bowling_instance
    	assert_instance_of Bowling, @bowling
    end

    def test_if_is_a_valid_frame_score
    	score = [3,4]
    	assert @bowling.valid_frame_score?(score,3)
    	score = [10,10]
    	assert @bowling.valid_frame_score?(score,11)
    	score = [10,9]
    	assert_not_equal @bowling.valid_frame_score?(score,4), true
    	score = []
    	assert_not_equal @bowling.valid_frame_score?(score,8), true
    	score = [10]
    	assert @bowling.valid_frame_score?(score,9)
    	score = [0,10]
    	assert @bowling.valid_frame_score?(score,1)
    	score = [5,'f']
    	assert @bowling.valid_frame_score?(score,2)
    end
end