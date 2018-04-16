require 'set'

class Task
	attr_reader :name
	attr_reader :command

	attr_reader :state

	attr_reader :dependencies

	def initialize(task_name, command)
		@name = task_name
		@command = command

		@state = :waiting
		@dependencies = Set.new
	end

	def set_state(state)
		@state = state
	end

	def add_dependency(dependency)
		@dependencies.add(dependency)
	end
end
