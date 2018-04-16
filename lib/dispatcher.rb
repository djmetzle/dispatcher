require_relative './parser.rb'

require_relative './pipeline.rb'

require 'yaml'

class Dispatcher
	def initialize docopt 
		unpack_options docopt

		parser = SpecFileParser.new @specfile_path
		@tasks = parser.get_tasks

		run_pipeline
	end

	private
	def unpack_options docopt
		@specfile_path = docopt["<spec_file>"]
	end

	def run_pipeline
		pipeline = Pipeline.new(@tasks)

		pipeline.run
	end
end
