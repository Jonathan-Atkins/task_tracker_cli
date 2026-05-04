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
  File.exist?(file_name)
end

def parse_file(file_name)
  read_file = File.read(file_name)
  JSON.parse(read_file)
end

def list_tasks(file_name)
  if file_valid?(file_name)
    parse_file(file_name)
  else
    []
  end
end

case command
when "add"
  valid_description?(description)
  tasks = list_tasks(file_name)

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
  tasks = list_tasks(file_name)
  if tasks.any?
    require "pry-nav"
    tasks.each do |task|
      puts "ID: #{task["id"]}"
      puts "Description: #{task["description"]}"
      puts "Status: #{task["status"]}"
      puts "Created: #{task["createdAt"]}"
      puts "Updated: #{task["updatedAt"]}"
      puts "Total Tasks = #{tasks.count}"
      puts "-" * 40
    end
  else
    puts "#{file_name} has no tasks listed"
  end

when "delete"
  # ! Find Task
  # *Is there a description in the argument? If not, exit 1 with a comment to say a task must be identified by its name or ID number
  tasks = list_tasks(file_name)
  if tasks.any?
    require "pry-nav"
    binding.pry
  end
  # ! Remove Tasks from File
  # * if task is found, remove it from the file
  # ! Confirm File has been deleted
  #   puts "Deleting task"
  # else
  #   puts "Unknown command"
end
