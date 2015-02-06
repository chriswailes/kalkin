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
	include Kalkin::AST

	def assert_resolvable(file_name)
		ast = get_ast(file_name)

		ast.visit @type_checker
		ast.visit @type_checker

#		pp ast

		assert_resolved(ast)
	end

	def assert_resolved(node)

#		puts "Visiting node of type #{node.class.name}"

		case node
		when Function
#			assert_instance_of(Kalkin::KlassType, node.type)
			assert(node.type.is_a?(Kalkin::KlassType), 'Failed to typecheck a function.')

		when RefBind
#			assert_instance_of(Kalkin::KlassType, node.type)
			assert(node.type.is_a?(Kalkin::KlassType), 'Failed to typecheck a refbind.')

		when Literal
#			assert_instance_of(Kalkin::KlassType, node.type)
			assert(node.type.is_a?(Kalkin::KlassType), 'Failed to typecheck a literal.')

		when ExprSequence
			assert_instance_of(Kalkin::KlassType, node.type)
#			assert(node.type.is_a?(Kalkin::KlassType), 'Failed to typecheck a exprsequence.')
		end

		node.children.flatten.each { |c| assert_resolved c }
	end

	def setup
		@tlns = Kalkin::AST::Namespace.new
		Kalkin::Backends::LLVM.populate_namespace(@tlns)

		@type_checker = Kalkin::Analysis::TypeChecker.new(@tlns)
	end

	def test_return_type_checking
		assert_resolvable('functions0.k')
		assert_resolvable('functions1.k')
#		assert_resolvable('functions2.k')
	end

	def test_param_checking
		assert_resolvable('functions3.k')
		assert_resolvable('functions4.k')
	end
end
