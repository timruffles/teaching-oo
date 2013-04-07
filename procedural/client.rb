require "set"
require "color"
include Color

# NOTE this isn't quite procedural as we're using the `while` instead of GOTOs
# NOTE DO NOT take ANY of the code in this file as an example of how to 
# write Ruby, Javascript or any modern code
# this is to give you a flavour of the low-level 'HOW TO DO IT' not 'WHAT I WANT' nature of procedural code
# NOTE to restate: this file is HOW NOT TO DO IT :)

# DATA

commands = [
  {
    "description" => "Your feed",
    "key" => "f"
  },
  {
    "description" => "Send message",
    "key" => "m"
  }
]


minutes = minute = 60
hours = hour = 60 * minutes

feed = [
  {
    "message" => "Hi there @you, great to see you last night",
    "sent_at" => Time.now - 5.3 * hours
  },
  {
    "message" => "@you great talk on Ruby, get in touch with Google HR!",
    "sent_at" => Time.now - 8.1 * hours
  }
]

platforms = {
  "twitter" => {
    "capabilities" => Set.new(["read","follow","write"])
  },
  "facebook" => {
    "capabilities" => Set.new(["read","follow","write"])
  },
  "rss" => {
    "capabilities" => Set.new(["read","follow"])
  },  
  "email" => {
    "capabilities" => Set.new(["read","write"])
  }  
}


# PROGRAM

puts colorize("Welcome to multi-message client 1.0",:blue)

# main loop
while(true) do

  puts "What would you like to do?"

  # print a left justified list of commands with descriptions
  max_len = 0
  index = 0
  while(index < commands.length) do
    length = commands[index]["description"].length 
    max_len = length if length > max_len
    index += 1
  end

  index = 0
  while(index < commands.length) do
    command = commands[index]
    puts "#{command["description"].ljust(max_len)}: #{command["key"]}"
    index += 1
  end

  # this reads from a special 'file' that the console writes into
  # and reads from
  terminal = IO.sysopen("/dev/tty", "w+")
  io = IO.open(terminal,"w+")
  command = io.gets.strip
  io.close

  puts "OK - #{command}"

  # main commands
  if command == "f"

    # show feed
    puts
    puts "Your messages:"
    index = 0
    while(index < feed.length) do
      feed_item = feed[index]
      puts "#{feed_item["message"]} : #{colorize(feed_item["sent_at"].to_s,:blue)}"
      index += 1
    end
    puts

  elsif command == "m"

    # capture message
    puts
    puts "Enter message:"
    terminal = IO.sysopen("/dev/tty", "w+")
    io = IO.open(terminal,"w+")
    message = io.gets.strip
    io.close

    puts colorize("Your message:",:blue) + " #{message}"

    # filter only platforms we can send messages on
    # NOTE can't do this procedurally in Ruby - this is method call
    sendable = platforms.select do |_,config|
      config["capabilities"].include? "write"
    end

    while(true) do

      # format platforms with a single character to choose them
      # NOTE can't iterate hashes procedurally in Ruby
      technique_options = sendable.map do |platform,_|
        "#{platform} (#{platform[0]})"
      end

      # how does user wish to send?
      puts "Send by: #{technique_options.join(", ")}"
      terminal = IO.sysopen("/dev/tty", "w+")
      io = IO.open(terminal,"w+")
      via = io.gets.strip
      io.close

      if via == "t"
        puts "Sending '#{message}' via Twitter..."
        # TODO sending code
        break
      elsif via == "f"
        puts "Sending '#{message}' via Facebook..."
        # TODO sending code
        break
      elsif via == "e"
        puts "Sending '#{message}' via Email..."
        # TODO sending code
        break
      else
        puts "Sorry #{via} is not a known method of sending a message"
      end
    end

  else

    puts colorize("Woops - I don't know how to '#{command}'",:red)

  end

end
