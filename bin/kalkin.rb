#!/usr/bin/env ruby

$: << File.join(File.dirname(File.expand_path(__FILE__)), '../lib')

############
# Includes #
############

# Standard Library
require 'pp'
require 'readline'

# Filigree
require 'filigree/configuration'

# Project
#require 'kalkin/ast_writer'
require 'kalkin/lexer'
#require 'kalkin/parser'
#require 'kalkin/symbol_table'
require 'kalkin/version'

###########################
# Configuraion Definition #
###########################

class Configuration
	include Filigree::Configuration

	usage "./kalkin.rb [options]"

	add_option Filigree::Configuration::HELP_OPTION

	attr_reader :input
	attr_reader :input_file_name
	attr_reader :mode

	def set_mode(mode)
		if not @mode.nil?
			raise 'Only one mode may be used.'
		end
		@mode = mode
	end

	help 'Lex the input'
	option 'lex', 'l' do
		set_mode :lex
	end

	help 'Parse the input'
	option 'parse', 'p' do
		set_mode :parse
	end

	help 'Show the parse tree'
	bool_option 'showparse', 'sp'

#	help 'Launch the REPL.'
#	option 'repl' do
#		set_mode :repl
#	end

	help 'Input expression'
	option 'exp', 'e' do |expression|
		@input = expression
	end

	help 'Input file'
	option 'file', 'f' do |name|
		if File.exist?(name)
			@input_file_name = name
			@input = File.open(name).read
		else
			raise "Can't open input file: #{name}"
			exit
		end
	end
end

####################
# Helper Functions #
####################

def lex(conf)
	pp Kalkin::Lexer.lex(conf.input)
end

def parse(conf)

	pt_val =
	if conf.showparse
		if conf.input_file_name
			File.basename(conf.input_file_name)
		else
			"input"
		end + ".parse.dot"
	else
		false
	end

	pp Kalkin::Parser.parse(Kalkin::Lexer.lex(conf.input), parse_tree: pt_val)
end

#def evaluate(contents)
#	begin
#		pp Kalkin::Lexer.lex(contents)

#		ast = Kalkin::Parser.parse(Kalkin::Lexer.lex(contents))

#		puts Kalkin::ASTWriter.new.visit(ast)

#	rescue RLTK::NotInLanguage => e
#		puts 'Invalid input'

#	rescue Kalkin::UnknownVariable => e
#		puts e.message
#	end
#end

#def repl(conf)
#	# TODO: If a file was given, its contents should be sourced into the
#	# environment before the REPL loads.
#	puts "Kalkin v#{Kalkin::VERSION} REPL (CTRL-D to exit)"
#	loop do
#		line = Readline.readline("Kalkin > ", true)
#		if not line
#			puts
#			break
#		else
#			evaluate line
#		end
#	end
#end

conf = Configuration.new(ARGV)

case conf.mode
when :lex   then lex conf
when :parse then parse conf
when :repl  then puts "Unsupported mode"
else
	puts "You must specify a mode"
end

#case conf.mode
#when :lex   then tokenize conf
#when :parse then dump_ast conf
#when :repl  then repl conf
#else
#	if conf.file
#		evaluate File.open(conf.file).read
#	elsif STDIN.isatty
#		repl conf
#	else
#		evaluate STDIN.read
#	end
#end
