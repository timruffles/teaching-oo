require "set"
require "color"
include Color

COMMANDS = {
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

FEED = [
  {
    "message" => "Hi there @you, great to see you last night",
    "sent_at" => Time.now - 5.3 * hours
  },
  {
    "message" => "@you great talk on Ruby, get in touch with Google HR!",
    "sent_at" => Time.now - 8.1 * hours
  }
]

PLATFORMS = {
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

def welcome tty
  tty.puts colorize("Welcome to multi-message client 1.0",:blue)
end

def main_command tty
  tty.puts "What would you like to do?"

  # print a left justified list of commands with descriptions
  max_just = COMMANDS.map {|_,command| command["description"].length }.max
  COMMANDS.each do |name,command|
    tty.puts "#{command["description"].ljust(max_just)}: #{command["key"]}"
  end
 
  terminal_read
end

def ask tty, msg
  tty.puts msg
  terminal_read
end

def terminal_read
  # this reads from a special 'file' that the console writes into
  # and reads from
  terminal = IO.sysopen("/dev/tty", "w+")
  IO.open(terminal,"w+") do |io|
    io.gets.strip
  end
end

def feed tty
  # show feed
  tty.puts
  tty.puts "Your messages:"
  FEED.each do |feed_item|
    tty.puts "#{feed_item["message"]} : #{colorize(feed_item["sent_at"].to_s,:blue)}"
  end
  tty.puts
end

def platforms_that_can capability
  # filter only platforms we can send messages on
  PLATFORMS.select do |_,config|
    config["capabilities"].include? capability
  end
end

def message tty
  # capture message
  tty.puts
  message = ask(tty,"Enter message:")

  tty.puts colorize("Your message:",:blue) + " #{message}"

  loop do

    # format platforms with a single character to choose them
    technique_options = platforms_that_can("write").map do |platform,_|
      "#{platform} (#{platform[0]})"
    end

    # how does user wish to send?
    tty.puts "Send by: #{technique_options.join(", ")}"
    via = terminal_read

    if via == "t"
      tty.puts "Sending '#{message}' via Twitter..."
      # TODO sending code
      break
    elsif via == "f"
      tty.puts "Sending '#{message}' via Facebook..."
      # TODO sending code
      break
    elsif via == "e"
      tty.puts "Sending '#{message}' via Email..."
      # TODO sending code
      break
    else
      tty.puts "Sorry #{via} is not a known method of sending a message"
    end
  end
end

def main tty

  welcome tty

  loop do

    command = main_command tty
    
    tty.puts "OK - #{command}"

    # main commands
    if command == "f"

      feed(tty)

    elsif command == "m"

      message(tty)

    else

      tty.puts colorize("Woops - I don't know how to '#{command}'",:red)

    end

  end
end

main STDOUT
