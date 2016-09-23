# Author:      Chris Wailes <chris.wailes@gmail.com>
# Project:     Kalkin
# Date:        2015/01/16
# Description: This file contains tests for the interpreter.

############
# Requires #
############

# Standard Library
require 'pp'

# Gems
require 'minitest/autorun'

# Kalkin
require 'kalkin/backends/interpreter'

class InterpTester < Minitest::Test

	include Kalkin::Backends::Interpreter

	def test_eden
		eden = make_eden()
		
		assert(eden)
		
		puts eden.to_s
	end
end
