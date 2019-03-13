require_relative "../bowling.rb"
require 'test/unit'

class TestBowling < Test::Unit::TestCase

	def test_return_true_if_value_is_a_fault
		value = 2
		assert_not_equal Bowling.is_a_fault?(value), true
		value = [3]
		assert_not_equal Bowling.is_a_fault?(value), true
		value = "abc"
		assert_not_equal Bowling.is_a_fault?(value), true
		value = "F"
		assert_equal Bowling.is_a_fault?(value), true
	end

	def test_return_true_if_value_is_a_strike
		value = 10
		assert Bowling.is_a_strike?(value)
		value = 9
		assert_not_equal Bowling.is_a_strike?(value), true
		value = [8,2]
		assert_not_equal Bowling.is_a_strike?(value), true
		value = ["F",10]
		assert_not_equal Bowling.is_a_strike?(value), true
		value = [10]
		assert Bowling.is_a_strike?(value)
	end

	def test_return_the_sum_of_the_elements
		value = [1,2,3,4,5,6]
		assert_equal Bowling.sum_elements(value), 21
		value = ["f",2,4]
		assert_equal Bowling.sum_elements(value), 0
	end

	def test_if_an_array_of_score_has_faults
		value = [7,5,4,"f"]
		assert Bowling.are_there_faults?(value)
		value = [7,5,4,"fffff"]
		assert_not_equal Bowling.are_there_faults?(value), true
		value = [10]
		assert_not_equal Bowling.are_there_faults?(value), true
	end

	def test_if_array_of_score_is_a_spare
		pinfalls = [2,8]
		assert Bowling.is_a_spare?(pinfalls)
		pinfalls = [3,4]
		assert_not_equal Bowling.is_a_spare?(pinfalls), true
		pinfalls = [0,10]
		assert Bowling.is_a_spare?(pinfalls)
		pinfalls = [9,"f"]
		assert_not_equal Bowling.is_a_spare?(pinfalls), true
	end

	def test_if_returns_the_correct_numbers_of_down_pins
		pinfalls = [4,5]
		assert_equal Bowling.calculate_knocked_down_pins(pinfalls), 9
		pinfalls = [5,5]
		assert_equal Bowling.calculate_knocked_down_pins(pinfalls), 10
		pinfalls = [4,"f"]
		assert_equal Bowling.calculate_knocked_down_pins(pinfalls), 4
		pinfalls = ["f","f"]
		assert_equal Bowling.calculate_knocked_down_pins(pinfalls), 0
	end

	def test_if_number_of_the_knocked_down_pin_is_valid
		(1..10).each do |knocked_down_pin|
			assert Bowling.is_a_valid_value?(knocked_down_pin)
		end
		knocked_down_pin = 11
		assert_not_equal Bowling.is_a_valid_value?(knocked_down_pin), true
		knocked_down_pin = -8
		assert_not_equal Bowling.is_a_valid_value?(knocked_down_pin), true
		knocked_down_pin = "f"
		assert Bowling.is_a_valid_value?(knocked_down_pin)
		knocked_down_pin = "abc"
		assert_not_equal Bowling.is_a_valid_value?(knocked_down_pin), true
		knocked_down_pin = 100
		assert_not_equal Bowling.is_a_valid_value?(knocked_down_pin), true
	end
end