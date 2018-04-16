require_relative './taskset.rb'

$stdout.sync = true

class Pipeline
	attr_reader :tasks

	def initialize tasks
		puts "Initialzing Pipeline.."
		@taskset = TaskSet.new tasks
		@logger = nil
		@children = {}
	end

	def set_logger logger
		@logger = logger
	end

	def run
		puts "Starting Pipeline.."
		print_taskset
		# Kick off inital processes
		iterate
		until @taskset.tasks_complete?
			iterate
		end
		puts "Finished Pipeline.."
		print_taskset
	end

	private
	def iterate
		ready_tasks = @taskset.get_ready
		ready_tasks.each { |name, task|
			puts "Running Ready Task: #{task.name}"
			launch_task task
		}
		if @children.keys.count > 0
			wait_for_compete
		end
		@taskset.update_dependencies
		puts "=== Completed Iteration"
	end

	def launch_task task
		puts "Starting task #{task.name}"
		pid = Process.fork { 
			puts "--- Running #{task.name}"
			output=`./#{task.command}`
			puts "Output from #{task.name}: #{output}"
			unless $?.success?
				abort "#{task.name} failed"
			end
			puts "--- Finished: #{task.name}"
		}
		@taskset.set_state task.name, :running
		@children[pid] = task.name
	end

	def wait_for_compete
		pid = Process.wait
		handle_exit @children[pid], $?.exitstatus
		@children.delete pid
	end

	def handle_exit name, status
		puts "Child #{name} exited with code #{status}"
		if status == 0
			@taskset.set_state name, :complete
		else
			@taskset.set_state name, :failed
		end
	end

	def print_taskset
		@taskset.taskset.each { |name, task| p task }
	end
end
