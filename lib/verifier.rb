class Verifier
	def initialize tasks
		@tasks = tasks
	end

	def verify
		verify_dependencies_exist
	end

	private
	def verify_dependencies_exist
		task_names = @tasks.map { |task| task.name }
		@tasks.each do |task|
			task.dependencies.each do |dependency|
				unless task_names.include?(dependency)
					abort "#{task.name}: Dependency #{dependency} doesn't exist!"
				end
			end
		end
	end


end
