require "set"
require "color"
include Color

# DATA

commands = {
  "feed" => {
    "description" => "Your feed",
    "key" => "f"
  },
  "message" => {
    "description" => "Send message",
    "key" => "m"
  }
}


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
loop do

  puts "What would you like to do?"

  # print a left justified list of commands with descriptions
  max_just = commands.map {|_,command| command["description"].length }.max
  commands.each do |name,command|
    puts "#{command["description"].ljust(max_just)}: #{command["key"]}"
  end

  # this reads from a special 'file' that the console writes into
  # and reads from
  terminal = IO.sysopen("/dev/tty", "w+")
  command = IO.open(terminal,"w+") do |io|
    io.gets.strip
  end

  puts "OK - #{command}"

  # main commands
  if command == "f"

    # show feed
    puts
    puts "Your messages:"
    feed.each do |feed_item|
      puts "#{feed_item["message"]} : #{colorize(feed_item["sent_at"].to_s,:blue)}"
    end
    puts

  elsif command == "m"

    # capture message
    puts
    puts "Enter message:"
    terminal = IO.sysopen("/dev/tty", "w+")
    message = IO.open(terminal,"w+") do |io|
      io.gets.strip
    end

    puts colorize("Your message:",:blue) + " #{message}"

    # filter only platforms we can send messages on
    sendable = platforms.select do |_,config|
      config["capabilities"].include? "write"
    end

    loop do

      # format platforms with a single character to choose them
      technique_options = sendable.map do |platform,_|
        "#{platform} (#{platform[0]})"
      end

      # how does user wish to send?
      puts "Send by: #{technique_options.join(", ")}"
      terminal = IO.sysopen("/dev/tty", "w+")
      via = IO.open(terminal,"w+") do |io|
        io.gets.strip
      end

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
