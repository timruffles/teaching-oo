################################################################################
#
# Introduction to Ruby on Rails
#
# Exercise Built In Classes
#
################################################################################

# 1. A popular built-in class is the Time class:
#    http://www.ruby-doc.org/docs/ProgrammingRuby/html/ref_c_time.html
#
#    In previous lessons, we ask out user to input the date.
#    We can make Ruby do all the hard work for us instead!
#
#    Print to the screen `Time.now` and see what prints.

puts "\nProblem 1:"

puts Time.now

# 2. Run it again! What changed?
#
# You can tell that the seconds changed.

puts "\nProblem 2:"

puts Time.now

# 3. Although neat, that output looks pretty ugly... What if you run
#    Time.now.day or Time.now.month?

puts "\nProblem 3:"

puts Time.now.day

puts Time.now.month

# 4. Take a look at `strftime`:
#    http://www.ruby-doc.org/docs/ProgrammingRuby/html/ref_c_time.html#Time.strftime
#
#    Construct a String using `strftime` so that the date prints out like:
#    Tuesday, September 19, 1985 at 09:15AM

puts "\nProblem 4:"

t = Time.now

puts t.strftime("%A, %B %d, %Y at %I:%M%p")
