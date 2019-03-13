require_relative "../start_score.rb"
require "test/unit"
class StartScoreCustom < StartScore

	def self.draw_final_score files
		message = %{}
		if files.empty?
			message << "There were not files"
		else
			message << "Starting Bowling score"
		end
		message
	end
end

class TestStartScore < Test::Unit::TestCase
	def test_returns_the_correct_output
		files = []
		message = StartScoreCustom.draw_final_score(files)
		assert_equal message, "There were not files"
		files = ["game.txt"]
		message = StartScoreCustom.draw_final_score(files)
		assert_equal message, "Starting Bowling score"
	end
end