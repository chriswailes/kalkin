# Author:		Chris Wailes <chris.wailes@gmail.com>
# Project: 	Kalkin
# Date:		2014/03/26
# Description:	This file contains the parser definition for Kalkin.

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

		left  ; nonassoc :IDENT ; right
		left  ; nonassoc        ; right :OPERATOR
		left  ; nonassoc        ; right :DOT

		p(:input) do
			c('NEWLINE*')             { |_|    NodeList.new [] }
			c('NEWLINE* input_prime') { |_, i| NodeList.new  i }
		end

		p :input_prime do
			c('top_level_defs')                        { |d|       [d] }
			c('.input_prime NEWLINE+ .top_level_defs') { |i, d| i << d }
		end

		p :top_level_defs do
			c('function_def') { |d| d }
			c('class_def')    { |d| d }
		end

		p :arg_list do
			c('')               { |_|      [] }
			c('arg_list_prime') { |args| args }
		end

		p :arg_list_prime do
			c('.expr_core')                       { |a|                  [a] }
			c('.expr_core COMMA .arg_list_prime') { |a, args| args.unshift a }
		end

		#########################################

		p :expr_core do
			c('literal') { |l| l }

			c('IDENT') { |i| @st.use i }

			# Single-line if-expr
			c('IF .expr_core THEN .expr_core ELSE .expr_core END') { |c, t, e| If.new(c, t, e) }

			# Function call
			c('.IDENT LPAREN .arg_list RPAREN') { |i, a| FunctionCall.new(i, ArgList.new(a)) }

			# Method call
			c('.expr_core DOT .IDENT LPAREN .arg_list RPAREN') { |r, m, a| MessageSend.new(m, r, ArgList.new(a))  }
			c('.expr_core DOT .IDENT')                         { |r, m|    MessageSend.new(m, r, ArgList.new([])) }

			# Operator call
			c('.expr_core .OPERATOR .expr_core') { |r, o, a| MessageSend.new(o, r, ArgList.new([a])) }
			c('OPERATOR expr_core')              { |o, r|    UnaryMessageSend.new(o, r)              }

			# Method/Operator Call
			c('.expr_core DOT .IDENT .OPERATOR .expr_core') do |s, m, o, a|
				SplitMessageSend.new m, o, s, ArgList.new([a])
			end
		end

		p(:expr_sequence, 'NEWLINE* .expr_sequence_prime') { |es| ExprSequence.new es }

		p :expr_sequence_prime do
			c('')                                       {                      [] }
			c('expr_core NEWLINE+ expr_sequence_prime') { |e, _, es| es.unshift e }
		end

		p :function_def do
#			c('function_sig ARROW literal') do |sig, _, l|
#				name, params = sig
#				Function.new name, [], l.type, params, ExprSequence.new([l])
#			end

#			c('.function_sig COLON .NSIDENT ARROW .expr_toplevel') do |sig, t, e|
#				name, params = sig
#				Function.new name, [], Type.new(t), params, ExprSequence.new([e])
#			end

			c('.function_sig COLON .NSIDENT NEWLINE .expr_sequence END') do |sig, t, es|
				@st.drop_frame

				name, params = sig
				Function.new(name, params, es, UnresolvedFunctionType.new(t))
			end
		end

		p :function_sig do
			c('DEF .IDENT')                           { |i|     [i, ParamList.new([])] }
			c('DEF .IDENT LPAREN .param_list RPAREN') { |i, ps| [i,                ps] }
		end

		p :literal do
			c('ATOM')    { |a| KAtom.new    a, UnresolvedType.new('Atom')    }
			c('FLOAT')   { |f| KFloat.new   f, UnresolvedType.new('Float')   }
			c('INTEGER') { |i| KInteger.new i, UnresolvedType.new('Integer') }
			c('STRING')  { |s| KString.new  s, UnresolvedType.new('String')  }
			c('BOOL')    { |b| KBool.new    b, UnresolvedType.new('Bool')    }
		end

		p :param_ident do
			c('IDENT')      { |id| id }
		end

		p :param_list do
			c('NEWLINE*')                  { |_|      ParamList.new []     }
			c('NEWLINE* .param_list_sub1') { |params| ParamList.new params }
		end

		p :param_list_sub1 do
			c('.param_ident COLON .NSIDENT NEWLINE*')                        { |i, t|               [@st.bind(i, UnresolvedType.new(t))] }
			c('.param_ident COLON .NSIDENT COMMA NEWLINE* .param_list_sub1') { |i, t, ps| ps.unshift(@st.bind(i, UnresolvedType.new(t))) }

			# Deferred types
			c('.param_ident COMMA NEWLINE* .param_list_sub1') do |i, ps|
				ps.unshift @st.bind(i, ps.first.type).elide_type
			end
		end

		token_hook(:DEF) {@st.add_frame}

		class Environment < Environment
			def initialize
				@errors = Array.new
				@st     = SymbolTable.new
			end
		end

		finalize explain: 'kalkin.automata'
	end
end
