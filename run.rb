# encoding=utf-8
# very silly argument parsing code
clients = ["procedural","object-oriented","structured"]
commands = ["test","run"]

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

def want text, from
  got = from.expect(text,2)
  if got.nil?
    puts in_red("Error:") + " expected '#{text}' but never saw it! #{in_red("✘")}"
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

if command == "test"

  require "pty"
  require "expect"

  PTY.spawn("ruby run.rb --#{client} run") do |r,w,_|

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

else
  require "#{client}/client"
end


