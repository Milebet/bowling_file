Ruby Challenge ​"ten-pin bowling​"

In order to see the result, please execute the following line (once located in the correct route of the project):

ruby start_score.rb

This will run the following instructions:
	bowling = Bowling.new() #set instance of the class Bowling
	bowling.get_file(file_name) #get the file or files to evaluated
	bowling.print_score #print the score screen on the command line
	bowling.set_winner #print a table of positions according to the max score of the game

Content of the older bowling

FOLDERS:
	games: Please, put all your txt with the pinfalls of the players here, The program will look into this folder to get all txt and print the correct scores for each one
		As an example in this folder you will find 4 txt files:
		1 - bowling_game.txt = Is the same example as the shown on the PDF with the players  jeff and john
		2 - game_2.txt = Has the scores for a perfect match with all the pinfalls equal to 10
		3 - game_3.txt = Simulates a game were all the players failed their turns with all of then in cero
		4 - game_4.txt = Is a file were the player did not make a strike or spare on the 10th frame, so that they do not have chances for extra turns

	modules: You will find two files here
		1 - draw_score.rb = It has some methods that helps to somulate the screen on the command line
		2 - file_creator.rb = Is a module used in the testing files, it has methods that creates directories nnd files

	tests: This folder contains all the unit testing.. I used Test/unit 
		1 - test_bowling = it test all the class method of the Bowling class (run: ruby tests/test_bowling.rb)
		2 - test_bowling_instance = it test instance method of the Bowling class (run: ruby tests/test_bowling_instance.rb)
		3 - test_content_file = it test the methods of the ContentFile class (run: ruby tests/test_content_file.rb)
		4 - test_file_txt = it test instance method of the FileTxt class (run: ruby tests/test_file_txt.rb)
		5 - test_start_score = it test instance method of the StartScore class (run: ruby tests/test_start_score.rb)

FILES:

	- file_txt.rb: This is a class with methods that indicates if a file exits, read the content of the file, etc
	- content_file.rb: This class helps to convert the content found in the file, in a hash. This is helpful bacause we will have the players set with their number of pinfalls
