# Author:      Chris Wailes <chris.wailes@gmail.com>
# Project:     Kalkin
# Date:        2014/11/29
# Description: This file contains tests for lexing, parsing, and printing programs.

############
# Requires #
############

# Gems
require 'minitest/autorun'

# Kalkin
require 'kalkin/lexer'
require 'kalkin/parser'
require 'kalkin/ast_writer'

#######################
# Classes and Modules #
#######################

class IsomorphismTester < Minitest::Test

	def assert_isomorphic(file_name, verbose = false)
		input  = File.open(File.join(File.dirname(File.expand_path(__FILE__)), 'inputs', file_name)) { |f| f.read }.chomp
		tokens = Kalkin::Lexer::lex(input)
		ast    = Kalkin::Parser::parse(tokens, verbose: verbose)
		string = Kalkin::ASTWriter.new.visit(ast)

		assert_equal(input, string)
	end

	def test_expressions
		assert_isomorphic('expr_ident.k')
		assert_isomorphic('expr_if0.k')
		assert_isomorphic('expr_if1.k')
	end

	def test_function_calls
		assert_isomorphic('expr_fun_call0.k')
		assert_isomorphic('expr_fun_call1.k')
	end

	def test_function_definitions
		assert_isomorphic('functions0.k')
		assert_isomorphic('functions1.k')
		assert_isomorphic('functions2.k')
		assert_isomorphic('functions3.k')
		assert_isomorphic('functions4.k')
	end

	def test_method_calls
		assert_isomorphic('expr_method_call0.k')
		assert_isomorphic('expr_method_call1.k')
	end

	def test_method_operator_calls
		assert_isomorphic('expr_method_operator0.k')
	end

	def test_operator
		assert_isomorphic('expr_operator0.k')
		assert_isomorphic('expr_operator1.k')
	end

	def test_literals
		assert_isomorphic('literal_atom.k')
		assert_isomorphic('literal_false.k')
		assert_isomorphic('literal_float.k')
		assert_isomorphic('literal_integer.k')
		assert_isomorphic('literal_string.k')
		assert_isomorphic('literal_true.k')
	end
end
