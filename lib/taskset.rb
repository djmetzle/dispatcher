require_relative './verifier.rb'

class TaskSet
	attr_reader :taskset

	def initialize tasks
		@taskset = tasks.map { |task| [ task.name, task] }.to_h

		verify

		update_dependencies
	end

	def tasks_complete?
		return @taskset.all? { |name, task|
			task.state == :complete || task.state == :failed
		}
	end

	def get_ready
		return @taskset.select { |name, task| 
			task.state == :ready
		}
	end

	def get_dependencies name
		unless @taskset[name]
			abort "Task named '#{name}' not found!"
		end
		return @taskset[name].dependencies
	end

	def set_state name, state
		@taskset[name].set_state state
		update_dependencies
	end

	def update_dependencies
		@taskset.select { |name, task|
			task.state == :waiting
		}.each { |name, _|
			dependencies = get_dependencies name
			if dependencies.all? { |dep|
					@taskset[dep].state == :complete
				}
				# Dependencies have been completed for task
				@taskset[name].set_state :ready
			end
			if dependencies.any? { |dep|
					@taskset[dep].state == :failed
				}
				# Dependency failed for task
				@taskset[name].set_state :failed
			end
		}
	end

	private

	def get_dependent_tasks taskname
		return @taskset.select { |name, task|
			task.dependencies.include?(taskname)
		}
	end

	def verify
		verifier = Verifier.new @taskset.values
		verifier.verify
	end
end
