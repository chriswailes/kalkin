# Author:      Chris Wailes <chris.wailes@gmail.com>
# Project:     Kalkin
# Date:        2015/01/16
# Description: This file contains tests for type checking.

############
# Requires #
############

# Standard Library
require 'pp'

# Gems
require 'minitest/autorun'

# Kalkin
require 'kalkin/ast'
require 'kalkin/lexer'
require 'kalkin/parser'
require 'kalkin/analysis/type_checking'
require 'kalkin/backends/llvm'

#######################
# Classes and Modules #
#######################

class TypeTester < Minitest::Test
	def assert_resolvable(file_name)
		ast = get_ast(file_name)
		@type_checker.visit ast

		assert_resolved(ast)
	end

	def assert_resolved(node)
		case node
		when Kalkin::AST::Function then assert_instance_of(Kalkin::KlassType, node.type)
		when Kalkin::AST::RefBind  then assert_instance_of(Kalkin::KlassType, node.type)
		else                            node.children.flatten.each { |c| assert_resolved c }
		end
	end

	def setup
		@tlns = Kalkin::AST::Namespace.new
		Kalkin::Backends::LLVM.populate_namespace(@tlns)

		@type_checker = Kalkin::Analysis::TypeChecker.new(@tlns)
	end

	def test_return_type_checking
		assert_resolvable('functions0.k')
		assert_resolvable('functions1.k')
		assert_resolvable('functions2.k')
	end

	def test_param_checking
		assert_resolvable('functions3.k')
		assert_resolvable('functions4.k')
	end
end
