require "set"
require "color"
include Color

class Message
  def initialize message, sent_at
    @message = message
    @sent_at = sent_at
  end
  def message
    @message
  end
  def sent_at
    @sent_at
  end
end


class Platform
  def initialize name, capabilities
    @name = name
    @capabilities = Set.new(capabilities)
  end
  def name
    @name
  end
  def send message
    puts "Sending '#{message}' via #{@name}"
  end
  def can? ability
    @capabilities.include? ability
  end
end


class OptionSet
  def initialize options
    @options = options
  end
  def commands
    @options.keys
  end
  def choice flag
    @options[flags_to_commands[flag]]
  end
  def formatted_choices
    max_just = commands.map {|option| option.length }.max
    # format platforms with a single character to choose them
    flags_to_commands.map do |flag,command|
      "#{command.ljust(max_just)}: (#{flag})"
    end
  end
  def flags_to_commands
    commands.inject({}) do |flags_to_values,command|
      flags_to_values[command[0].downcase] = command
      flags_to_values  
    end
  end
  def flags
    flags_to_commands.keys
  end
  def valid? flag
    !!choice(flag)
  end
end

class Ui
  def initialize tty
    @tty = tty
  end
  def puts msg = ""
    @tty.puts msg
  end
  def gets
    @tty.gets msg
  end

  def ask tty, msg
    puts msg
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

end

class TopMenuUi < Ui
  def initialize tty, commands
    @tty = tty
    @commands = commands
  end
  def call

    welcome

    loop do
      main_command
    end
  end
  def welcome
    puts colorize("Welcome to multi-message client 1.0",:blue)
  end

  def main_command
    puts "What would you like to do?"

    options = OptionSet.new(@commands)
    options.formatted_choices.each do |formatted|
      puts formatted
    end
   
    command = terminal_read

    choice = options.choice command

    unless choice
      colorize("Woops - I don't know how to '#{command}'",:red)
      return
    end

    puts "OK - #{command}"
    choice.call
  end
end

class FeedUi < Ui
  def initialize tty, feed
    @tty = tty
    @feed = feed
  end
  def call
    # show feed
    puts
    puts "Your messages:"
    @feed.each do |feed_item|
      puts "#{feed_item.message} : #{colorize(feed_item.sent_at.to_s,:blue)}"
    end
    puts
  end
end

class MessageUi < Ui
  def initialize tty, platforms
    @tty = tty
    @platforms = platforms
  end
  def call
    # capture message
    puts
    message = ask(@tty,"Enter message:")

    puts colorize("Your message:",:blue) + " #{message}"

    loop do

      platforms_to_names = platforms_that_can("write").reduce({}) do |by_name,platform|
        by_name[platform.name] = platform
        by_name
      end

      options = OptionSet.new(platforms_to_names)

      # how does user wish to send?
      puts "Send by: #{options.formatted_choices.join(", ")}"
      via = terminal_read

      platform = options.choice via
      raise "Can't send via #{via}" unless platform

      platform.send message
      break

    end
  end

  def platforms_that_can capability
    # filter only platforms we can send messages on
    @platforms.select do |platform|
      platform.can? capability
    end
  end

end

def main tty
  minutes = minute = 60
  hours = hour = 60 * minutes
  feed = [
    Message.new("Hi there @you, great to see you last night",Time.now - 5.3 * hours),
    Message.new("@you great talk on Ruby, get in touch with Google HR!",Time.now - 8.1 * hours)
  ]


  feed_ui = FeedUi.new(tty,feed)


  message_ui = MessageUi.new(tty,[
    Platform.new("Twitter",["read","follow","write"]),
    Platform.new("Facebook",["read","follow","write"]),
    Platform.new("RSS",["read","follow"]),
    Platform.new("Email",["read","write"])
  ])

  top_menu = TopMenuUi.new(
    tty,
    {
      "feed" => feed_ui,
      "message" => message_ui
    }
  )

  top_menu.call
end

main(STDOUT)
