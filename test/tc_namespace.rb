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

	def test_top_level

		files = [
			'functions0.k',
			'functions1.k',
			'functions2.k',
			'functions3.k',
			'functions4.k',
		]

		mp_ast        = Kalkin::AST::Namespace.new('top_level')
		file_contents = files.map { |fn| File.open(File.join(File.dirname(File.expand_path(__FILE__)), 'inputs', fn)) { |f| f.read }.chomp }
		string        = file_contents.join("\n")
		sp_ast        = Kalkin::Parser.parse(Kalkin::Lexer.lex(string))

		file_contents.each do |s|
			mp_ast.add_members Kalkin::Parser.parse(Kalkin::Lexer.lex(s))
		end

		assert_equal(Kalkin::ASTWriter.new.visit(sp_ast), Kalkin::ASTWriter.new.visit(mp_ast))
	end
end
