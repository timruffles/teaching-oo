################################################################################
#
# Introduction to Ruby on Rails
#
# Code Along Built In Classes
#
################################################################################
#We are going to use the built in class 'File' to create a .txt file and add some text to it. 

# 1. Ask the user for a file name. Open or create a file by that name, 
# by adding file extension".txt" to the users input.
# Ask the user to write a sentence. Append that sentence to the file, preceded
# by the current date and time. Use newline character ("\n") as needed. Be sure to close the file. 
# Check your work on the file system.

def sentence_storer()
	puts("Give me a file name")
	file_name = gets().chomp() + ".txt"

	puts("Give me a sentence")
	sentence = gets().chomp()

	File.open(file_name,"w+") do |file|
		file.write(sentence)
	end
end



# 2. Use the File class to open the file created above (using the same input from above), to read and 
# display its contents to the terminal window. Read documentation on the .gets method, and write the 
# necessary loop code.

def sentence_reader()
	puts("Give me a file name")
	file_name = gets().chomp()
	
	unless(File.exist?(file_name))
		abort("File '#{file_name}' does not exist, sorry")
	end

	File.open(file_name,"r") do |file|
		puts(file.read())
	end
end

sentence_reader()
