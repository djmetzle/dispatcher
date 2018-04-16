class PipelineLogger
	DEFAULT_LOGDIR = './pipeline'
	PIPELINE_LOGFILE = './pipeline.log'

	def initialize logdir
		@logfile = logdir || DEFAULT_LOGDIR
	end

	def log_start taskname

	end

	def log_end taskname

	end
end
