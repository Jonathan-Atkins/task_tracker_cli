require "json"

command = ARGV[0]
description = ARGV[1]

case command
when "add"
  puts "Adding task: #{description}"
when "list"
  puts "Listing tasks"
when "delete"
  puts "Deleting task"
else
  puts "Unknown command"
end