require_relative "./task.rb"

class SpecFileParser
	attr_reader :rawspec

	def initialize specfile_path
		@specfile_path = specfile_path
		@rawspec = load_yaml get_specfile_contents
		validate_raw_spec
	end

	def get_tasks
		tasklist = @rawspec["TASKS"]
		tasks = tasklist.map { |task_name, command|
			task = Task.new(task_name, command)
			dependencies = get_dependencies(task_name)
			dependencies.each { |dep|
				task.add_dependency(dep)
			}
			task
		}
		return tasks
	end

	private
	def get_dependencies(task_name)
		dependencies = @rawspec["DEPENDENCIES"]
		task_dependencies = dependencies[task_name]
		task_dependencies ||= []
		return task_dependencies
	end

	def get_specfile_contents
		begin
			contents = File.read(@specfile_path)
		rescue
			puts "Could not read file: #{@specfile_path}"
			exit 1
		end
		return contents
	end

	def load_yaml contents
		begin
			spec = YAML.load(contents)
		rescue Exception => e
			puts "Failed Parsing #{@specfile_path} as YAML!"
			puts e.message
			puts e.backtrace.inspect
		end
		return spec
	end
	
	def validate_raw_spec
		unless @rawspec["TASKS"] 
			raise "No TASKS defined in Specfile!"
		end

		unless @rawspec["DEPENDENCIES"] 
			raise "No DEPENDENCIES defined in Specfile! Please define an empty DEPENDENCIES block."
		end
	end
end
