# Author:		Chris Wailes <chris.wailes@gmail.com>
# Project: 	Kalkin
# Date:		2014/03/26
# Description:	This file contains the test suit for Kalkin.  It requires the
#			individual tests from their respective files.

############
# Requires #
############

# Filigree
require 'filigree/request_file'

# Kalkin
require 'kalkin/lexer'
require 'kalkin/parser'

# Standard Library
request_file('simplecov', 'SimpleCov is not installed.') do
	SimpleCov.start do
		add_filter 'tc_*'
	end
end

####################
# Helper Functions #
####################

def get_ast(file_name, verbose = false)
	input  = File.open(File.join(File.dirname(File.expand_path(__FILE__)), 'inputs', file_name)) { |f| f.read }.chomp
	tokens = Kalkin::Lexer::lex(input)
	ast    = Kalkin::Parser::parse(tokens, verbose: verbose)
end

##############
# Test Cases #
##############

require 'tc_isomorphism.rb'
require 'tc_namespace.rb'
require 'tc_types.rb'
