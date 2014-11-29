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

#######################
# Classes and Modules #
#######################

module Kalkin
	class Parser < RLTK::Parser

		include Kalkin::AST

		left  ; nonassoc :IDENT ; right
		left  ; nonassoc        ; right :OPERATOR
		left  ; nonassoc        ; right :DOT

		start :expr_core

		p :expr_core do
			c('literal')                  { |l| l }
			c('LPAREN .expr_core RPAREN') { |e| e }

			c('IDENT') { |i| UnresolvedSymbol.new i }

			# Single-line if-expr
			c('IF .expr_core THEN .expr_core ELSE .expr_core END') { |c, t, e| If.new c, t, e }

			# Function call
			c('.IDENT LPAREN .arg_list RPAREN') { |i, a| FunctionCall.new i, a }

			# Method call
			c('.expr_core DOT NEWLINE* .IDENT LPAREN .arg_list RPAREN') { |s, m, a| MessageSend.new m, s,  a }
			c('.expr_core DOT NEWLINE* .IDENT')                         { |s, m|    MessageSend.new m, s, [] }

			# Operator call
			c('.expr_core .OPERATOR NEWLINE* .expr_core') { |s, o, a| MessageSend.new o, s, [a] }
			c('OPERATOR expr_core')                       { |o, s|    UnaryMessageSend.new  o, s }

			# Method/Operator Call
			c('.expr_core DOT NEWLINE* .IDENT .OPERATOR NEWLINE* .expr_core') do |s, m, o, a|
				SplitMessageSend.new m, o, s, [a]
			end
		end

		p :literal do
			c('ATOM')    { |a| KAtom.new    a }
			c('FLOAT')   { |f| KFloat.new   f }
			c('INTEGER') { |i| KInteger.new i }
			c('STRING')  { |s| KString.new  s }
			c('BOOL')    { |b| KBool.new    b }
		end

		p :arg_list do
			c('NEWLINE*')                 { |_|  [] }
			c('NEWLINE* .arg_list_prime') { |as| as }
		end

		p :arg_list_prime do
			c('.expr_core NEWLINE*')                       { |a|              [a] }
			c('.expr_core COMMA NEWLINE* .arg_list_prime') { |a, as| as.unshift a }
		end

		finalize explain: 'kalkin.automata'
	end
end
