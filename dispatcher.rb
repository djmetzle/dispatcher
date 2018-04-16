#!/usr/bin/ruby -w

require 'docopt'

require_relative './lib/dispatcher.rb'

doc = <<DOCOPT
Dispatcher

A Commandline pipeline dispatch tool.

Usage:
	#{__FILE__} <spec_file>

Options:
	-h, --help		Show this screen.
	
DOCOPT

begin
	Dispatcher.new Docopt::docopt(doc)
rescue Docopt::Exit => e
	puts e.message
end
