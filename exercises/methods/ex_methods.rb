################################################################################
#
# Introduction to Ruby on Rails
#
# Exercise Methods
#
################################################################################
#
# Below are variables that we will use in this exercise.
#
################################################################################

responses = Hash.new

responses[:positive] =  [ "It is certain", "It is decidedly so",
                          "Without a doubt", "Yes - definitely",
                          "You may rely on it", "As I see it, yes",
                          "Most likely", "Outlook good", "Yes",
                          "Signs point to yes" ]

responses[:neutral] =  [ "Reply hazy, try again", "Ask again later",
                         "Better not tell you now", "Cannot predict now",
                         "Concentrate and ask again" ]

responses[:negative] = [ "Don't count on it", "My reply is no",
                         "My sources say no", "Outlook not so good",
                         "Very doubtful" ]

################################################################################
#
# 1. We're going to create our first method!
#
#    In this exercise, we will create a simple method that will take
#    a String and return a random answer.
#
#    Start by defining a new method called 'forecast_future' that
#    accepts 2 parameter ('question' and 'responses').
#
#
# 2. Within your new method, call `responses.keys[rand(responses.size)]` what
#    this does is uses the `rand` method with the size of the Hash to
#    randomly pick a number. If the size of your Hash is 3, the number can
#    be anything between 1 and 3.
#
#    random_key = responses.keys[rand(responses.size)]
#
# 3. Next, access the value of our key and use `sample` on it to choose
#    a random value from our Array. It's similar to what we did with
#    randomly getting a value from our Hash, but done differently.
#
#    puts responses[random_key].sample
#
# 4. Outside of your method, call forecast_future and pass it a String
#    (ask it a question!) and the responses variable that was created
#    above.
#
#    forecast_future("Will I win the lottery?", responses)
#
# 5. Run your program multiple times and watch your random responses
#    appear!
#
################################################################################
#
# Student's Solution:
#
################################################################################

