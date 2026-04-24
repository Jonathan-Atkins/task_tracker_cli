require "json"
require "titleize"

command     = ARGV[0]
description = ARGV[1]

case command
when "add"
  if !description || description.empty?
    puts "Error: Description required"
    exit 1
  else
    description = description.titleize
  end

  if File.exist?("tasks.json")
    read_file   = File.read("tasks.json")
    if !read_file.empty?
      tasks = JSON.parse(read_file)
    end
  else
    tasks = []
    File.write("tasks.json", "")
  end

  tasks.each do |task|
    if task["description"] == description
      puts "Error: #{description} has already been added"
      exit 1
    end
  end

  new_task = {
    id: tasks.length + 1,
    description: description,
    status: "todo"
  }

  tasks << new_task

  File.write("tasks.json", JSON.pretty_generate(tasks))
  puts "#{description} has been added"
  # when "list"
  #   puts "Listing tasks:"
  # when "delete"
  #   puts "Deleting task"
  # else
  #   puts "Unknown command"
end
