require "json"
require "titleize"

command = ARGV[0]&.strip&.downcase
description = ARGV[1]&.strip
file_name = "tasks.json"

def valid_description?(description)
  if description.nil? || description.empty?
    puts "Error: Description cannot be empty"
    exit 1
  end
end

def file_valid?(file_name)
  if File.exist?(file_name)
    read_file = File.read(file_name)
    tasks = if !read_file.empty?
      JSON.parse(read_file)
    else
      []
    end
  else
    tasks = []
    File.write(file_name, "[]")
  end
  tasks
end

case command
when "add"
  valid_description?(description)
  tasks = file_valid?(file_name)

  if tasks.any? { |task| task["description"] == description }
    puts "Error: #{description} has already been added"
    exit 1
  end

  new_task = {
    id: tasks.empty? ? 1 : tasks[-1]["id"] + 1,
    description: description,
    status: "todo",
    createdAt: Time.now,
    updatedAt: Time.now
  }

  tasks << new_task

  File.write(file_name, JSON.pretty_generate(tasks))
  puts "#{description} has been added"
when "list"
  tasks = file_valid?(file_name)

  if tasks.empty?
    puts "There are no tasks in #{file_name}"
  else
    tasks.each do |task|
      puts "ID: #{task["id"]}"
      puts "Description: #{task["description"]}"
      puts "Status: #{task["status"]}"
      puts "Created: #{task["createdAt"]}"
      puts "Updated: #{task["updatedAt"]}"
      puts "Total Tasks = #{tasks.count}"
      puts "-" * 40
    end
  end

  # when "delete"
  #   puts "Deleting task"
  # else
  #   puts "Unknown command"
end
