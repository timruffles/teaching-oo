# encoding=utf-8
# very silly argument parsing code
clients = ["procedural","object-oriented","structured"]
commands = ["test","run","extended"]

flags, command = ARGV.partition {|a| /^--/ =~ a }

# parse command
if command.length > 1
  abort "Too many commands"
end
command = command.first
unless commands.include? command
  abort "Unknown command #{command}"
end


flags = flags.map {|a| a.gsub("--","") }
client = flags.first

unless clients.include? client
  abort "Please specific one of #{clients.map {|c| "--#{c}" }.join(", ")}, eg: --#{clients.first}"
end

$LOAD_PATH.unshift(File.dirname(__FILE__))

require "color"
include Color

def want text, from, msg = false
  got = from.expect(text,2)
  if got.nil?
    if msg
      puts "#{in_red("✘")}: #{msg}"
    else
      puts in_red("Error:") + " expected '#{text}' but never saw it! #{in_red("✘")}"
    end
    exit
  else
    puts got if ENV["DEBUG"]
    puts "#{in_green("Saw")} #{text} #{in_green("✔")}"
  end
end

require "timeout"

def what_do_i_get from
  buf = ""
  loop do
    begin
      timeout(2) do
        buf += from.readchar
      end
    rescue Timeout::Error
      break  
    end
  end
  buf
end
def enter msg, to
  puts "#{in_blue("Enter")} #{msg}"
  to.puts msg
end
def core_test r,w
  want("Welcome",r)

  want("What would you like to do",r)
  want("feed",r)
  want("message",r)

  enter("m",w)

  want("OK",r)
  want("Enter message",r)

  enter("Hi @matz",w)

  want("Send by",r)

  enter("t",w)

  want("Sending",r)
  want("Hi @matz",r)
  want("via Twitter",r)

  want("What would you like to do",r)

  enter("f",w)
  want("Hi there @you",r)
end
def extended r,w

  want("@matz: ",r,"Display user names before messages in feed in '@USER_NAME:' format - eg '@matz: Ruby 2 is going to be great'")

  want("follow",r,"Add a 'FollowUi' to the system, to allow a user to follow another user.\n- Define a 'User' class\n- use it to pass it a list of users created from authors of the messages in Feed\n- pass the list to FollowUi")

  enter("f",w,"Extend OptionSet to use specific flags for options, with a description. We'll be adding lots more commands")
  want("Choose user to follow",r,"Ask the user 'Choose user to follow (1-3)', and display the possible choices below in '1. matz' format")

  enter("14",w)
  want("No option 14",r,"Validate the user picks a user from the list (1-3), and give an error message startig 'No option NUMBER' - eg 'No option 14'")

  enter("2",w)
  want("Following @matz",r,"Indicate the user is being followed by outputting 'Following @user'")

  want("following",r,"Add a 'FollowingUi' that shows users you are following\n- store users followed in a Set\n- ensure the FollowUi adds users to this set")
  enter("fi",w)
  want("1. @matz",r,"List the users being followed, one per line, like '1. @matz")

  want("unfollow",w,"Allow user to unfollow a user. You'll need to share a data-structure between the FollowUI and UnfollowUi to achieve this")
  enter("uf",w)
  enter("1",w)
  want("Unfollowed @matz",r,"Tell user they've unfollowed by outputting 'Unfollowed @USER', eg 'Unfollowed @matz")

  enter("fi")
  want("Not following anybody",r,"Tell user when they're not following anybody by outputting 'Not following anybody' in FollowingUi when their list of people to follow is empty. Ensure that\n- when you unfollowed the list of followers is updated\n- FollowingUi and UnfollowUi are using the same list")


end

case command
when "test","extended"

  require "pty"
  require "expect"

  PTY.spawn("ruby run.rb --#{client} run") do |r,w,_|
    core_test r, w
    extended r,w if command == "extended"
  end

else

  require "#{client}/client"
end


