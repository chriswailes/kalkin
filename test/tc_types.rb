# Author:      Chris Wailes <chris.wailes@gmail.com>
# Project:     Kalkin
# Date:        2015/01/16
# Description: This file contains tests for type checking.

############
# Requires #
############

# Gems
require 'minitest/autorun'

# Kalkin
require 'kalkin/ast'
require 'kalkin/lexer'
require 'kalkin/parser'
require 'kalkin/analysis/type_checking'

#######################
# Classes and Modules #
#######################

class TypeTester < Minitest::Test
	def assert_resolved(node)
		match node do
			with(RefBind.(_, t)) {  assert_instance_of(KlassType, t) }
			with(KNode)          { |n| n.children.each { |c| visit c }}
		end
	end

	def setup
	end

	def test_param_checking

	end
end
