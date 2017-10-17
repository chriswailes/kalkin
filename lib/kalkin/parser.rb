# Author:      Chris Wailes <chris.wailes@gmail.com>
# Project:     Kalkin
# Date:        2014/03/26
# Description: This file contains the parser definition for Kalkin.

############
# Requires #
############

# RLTK
require 'rltk/parser'

# Project
require 'kalkin/ast'
require 'kalkin/symbol_table'
require 'kalkin/type'

#######################
# Classes and Modules #
#######################

module Kalkin
	class Parser < RLTK::Parser

		include Kalkin::AST

#		left :NEWLINE ; nonassoc ; right

#		left ; nonassoc :IDENT ; right
#		left ; nonassoc        ; right :OPERATOR
#		left ; nonassoc        ; right :DOT

		###############################
		# Top Level Input Productions #
		###############################

		p :input do
			c('NEWLINE*')                       { |_| NodeList.new [] }
			c('NEWLINE* .input_prime NEWLINE*') { |i| NodeList.new  i }
		end

		p :input_prime do
			c('top_level_defs')                        { |d|       [d] }
			c('.input_prime NEWLINE+ .top_level_defs') { |i, d| i << d }
		end

		p :top_level_defs do
			c('function_def') { |d| d }
		end

		############################
		# Literals and Expressions #
		############################

		p :literal do
			c('ATOM')    { |a| KAtom.new    a, UnresolvedType.new('Atom')    }
			c('FLOAT')   { |f| KFloat.new   f, UnresolvedType.new('Float')   }
			c('INTEGER') { |i| KInteger.new i, UnresolvedType.new('Integer') }
			c('STRING')  { |s| KString.new  s, UnresolvedType.new('String')  }
			c('BOOL')    { |b| KBool.new    b, UnresolvedType.new('Bool')    }
		end

		p :expr do
			c(:expr_single_line) { |o| o }
			c(:expr_multi_line)  { |o| o }
		end

		list :expr_sequence, :expr_multi_line, 'NEWLINE+'

		p :expr_core do
			c('literal') { |l|         l }
			c('IDENT')   { |i| @st.use i }
		end

		p :expr_single_line do

			# Core expressions
			c('expr_core') { |e| e }

			# Single-line if-expr
			c('IF .expr_single_line THEN .expr_single_line ELSE .expr_single_line END') { |c, t, e| If.new(c, t, e) }

			# Function call
			c('.IDENT LPAREN .arg_list_single_line RPAREN') { |i, a| FunctionCall.new(i, ArgList.new(a)) }

			# Method call
			c('.expr_single_line DOT .IDENT LPAREN .arg_list_single_line RPAREN') { |r, m, a| MessageSend.new(m, r, ArgList.new(a))  }
			c('.expr_single_line DOT .IDENT')                                     { |r, m|    MessageSend.new(m, r, ArgList.new([])) }

			# Operator call
			c('.expr_single_line .OPERATOR .expr_single_line') { |r, o, a| MessageSend.new(o, r, ArgList.new([a])) }
			c('OPERATOR expr_single_line')                     { |o, r|    UnaryMessageSend.new(o, r)              }

			# Method/Operator Call
			c('.expr_single_line DOT .IDENT .OPERATOR .expr_single_line') do |s, m, o, a|
				SplitMessageSend.new m, o, s, ArgList.new([a])
			end
		end

		p :expr_multi_line do

			# Core expressions
			c('expr_core') { |e| e }

			# If expressions
			c('IF .expr_multi_line THEN NEWLINE* .expr_multi_line ELSE .expr_multi_line END') { |c, t, e| If.new(c, t, e) }
			c('IF .expr_single_line NEWLINE+ .expr_multi_line ELSE .expr_multi_line END')     { |c, t, e| If.new(c, t, e) }

			# Function call
			c('.IDENT LPAREN NEWLINE* .arg_list_multi_line NEWLINE* RPAREN') { |i, a| FunctionCall.new(i, ArgList.new(a)) }

			# Method call
			c('.expr_multi_line DOT .IDENT LPAREN NEWLINE* .arg_list_multi_line NEWLINE* RPAREN') { |r, m, a| MessageSend.new(m, r, ArgList.new(a))  }
			c('.expr_multi_line DOT .IDENT')                                                      { |r, m|    MessageSend.new(m, r, ArgList.new([])) }

			# Operator call
			c('.expr_multi_line .OPERATOR NEWLINE* .expr_multi_line') { |r, o, a| MessageSend.new(o, r, ArgList.new([a])) }
			c('OPERATOR expr_multi_line')                             { |o, r|    UnaryMessageSend.new(o, r)              }

			# Method/Operator Call
			c('.expr_multi_line DOT .IDENT .OPERATOR NEWLINE* .expr_multi_line') do |s, m, o, a|
				SplitMessageSend.new m, o, s, ArgList.new([a])
			end
		end

		##################
		# Argument Lists #
		##################

		p :arg_list do
			c('arg_list_single_line') { |o| o }
			c('arg_list_multi_line')  { |o| o }
		end

		p :arg_list_single_line do
			c('')                           {          [] }
			c('arg_list_single_line_prime') { |args| args }
		end

		p :arg_list_single_line_prime do
			c('.expr_single_line')                                   { |a|                  [a] }
			c('.expr_single_line COMMA .arg_list_single_line_prime') { |a, args| args.unshift a }
		end

		p :arg_list_multi_line do
			c('')                           { ||       [] }
			c('arg_list_single_line_prime') { |args| args }
		end

		p :arg_list_multi_line_prime do
			c('.expr_multi_line')                                                    { |a|                  [a] }
			c('.expr_multi_line NEWLINE* COMMA NEWLINE* .arg_list_multi_line_prime') { |a, args| args.unshift a }
		end

		########################
		# Function Definitions #
		########################

		p :function_def do
			c('.function_sig ARROW .NSIDENT NEWLINE+ .expr_sequence NEWLINE* END') do |sig, t, es|
				@st.drop_frame

				name, params = sig
				Function.new(name, params, es, UnresolvedFunctionType.new(t))
			end
		end

		p :function_sig do
			c('DEF .IDENT')                                             { |i|     [i, ParamList.new([])] }
			c('DEF .IDENT LPAREN NEWLINE* .param_list NEWLINE* RPAREN') { |i, ps| [i,                ps] }
		end

		###################
		# Parameter Lists #
		###################

		p :param_list do
			c('')                 { ||   [] }
			c('param_list_prime') { |ps| ps }
		end

		p :param_list_prime do
			c('.IDENT COLON .NSIDENT')                                           { |i, t|               [@st.bind(i, UnresolvedType.new(t))] }
			c('.IDENT COLON .NSIDENT NEWLINE* COMMA NEWLINE* .param_list_prime') { |i, t, ps| ps.unshift(@st.bind(i, UnresolvedType.new(t))) }

			# Deferred types
#			c('.IDENT COMMA NEWLINE* .param_list_prime') do |i, ps|
#				ps.unshift @st.bind(i, ps.first.type).elide_type
#			end
		end

		#######################
		# Parsing Environment #
		#######################

#		token_hook(:DEF) {@st.add_frame}

		class Environment < Environment
			def initialize
				@symbol_table  = @st = SymbolTable.new
#				@user_messages = @um = user_messages
			end
		end

		################
		# Finalization #
		################

		finalize explain: 'kalkin.automata'
	end
end
