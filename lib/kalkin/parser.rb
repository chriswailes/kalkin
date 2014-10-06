# Author:		Chris Wailes <chris.wailes@gmail.com>
# Project: 	Kalkin
# Date:		2014/03/26
# Description:	This file contains the parser definition for Kalkin.

############
# Requires #
############

# RLTK
require 'rltk/parser'

#######################
# Classes and Modules #
#######################

class Kalkin::Parser < RLTK::Parser

	include AST

	left  ; nonassoc :IDENT ; right
	left  ; nonassoc        ; right :OPERATOR
	left  ; nonassoc        ; right :DOT

	p(:input) do
		c('NEWLINE*')             { |_|    [] }
		c('NEWLINE* input_prime') { |_, i|  i }
	end

	p :input_prime do
		c('function_def')                        { |f|       [f] }
		c('.input_prime NEWLINE+ .function_def') { |i, f| i << f }

#		c('')                                  {      [] }
#		c('function_def NEWLINE+ input_prime') { |f, _, i| i.unshift f}
	end

	p :arg_list do
		c('NEWLINE*')                 { |_|     [] }
		c('NEWLINE* .arg_list_prime') { |as| as }
	end

	p :arg_list_prime do
		c(' expr_core NEWLINE*')                       { |a|              [a] }
		c('.expr_core COMMA NEWLINE* .arg_list_prime') { |a, as| as.unshift a }
	end

	p :expr_toplevel do
		c('expr_midlevel') { |e| e }
		c('if_expr')       { |e| e }
	end

	p :expr_midlevel do
		c('expr_core') { |e| e }
		c('let_expr')  { |e| e }
	end

	p :expr_core do
		c('literal')                  { |l|       l }
		c('LPAREN .expr_core RPAREN') { |e| e }

		# Single-line if-expr
		c('IF .expr_midlevel THEN .expr_core ELSE .expr_core END') { |c, t, e| If.new nil, c, t, e }

		# Function call
		c('.IDENT LPAREN .arg_list RPAREN') { |i, a| FunctionCall.new nil, i, a }

		# Method call
		c('.expr_core DOT NEWLINE* .IDENT LPAREN .arg_list RPAREN') { |s, m, a| MessageSend.new nil, m, s,  a }
		c('.expr_core DOT NEWLINE* .IDENT')                         { |s, m|    MessageSend.new nil, m, s, [] }

		# Operator call
		c('expr_core OPERATOR NEWLINE* expr_core') { |s, o, _, a| MessageSend.new nil, o, s, [a] }
		c('OPERATOR expr_core')                    { |o, s|       UnaryMessageSend.new nil, o, s }

		# Method/Operator Call
		c('.expr_core DOT NEWLINE* .IDENT .OPERATOR NEWLINE* .expr_core') do |s, m, o, a|
			SplitMessageSend.new nil, m, o, s, [a]
		end
	end

	p(:expr_sequence, 'NEWLINE* .expr_sequence_prime') { |es| ExprSequence.new es }

	p :expr_sequence_prime do
		c('')                                           {                      [] }
		c('expr_toplevel NEWLINE+ expr_sequence_prime') { |e, _, es| es.unshift e }
	end

	p :function_def do
		c('function_sig ARROW literal') do |sig, _, l|
			name, params = sig
			Function.new name, [], l.type, params, ExprSequence.new([l])
		end

		c('.function_sig COLON .NSIDENT ARROW .expr_toplevel') do |sig, t, e|
			name, params = sig
			Function.new name, [], Type.new(t), params, ExprSequence.new([e])
		end

		c('.function_sig COLON .NSIDENT NEWLINE .expr_sequence END') do |sig, t, es|
			name, params = sig
			Function.new name, [], Type.new(t), params, es
		end
	end

	p :function_sig do
		c('DEF .IDENT')                           { |i|     [i, []] }
		c('DEF .IDENT LPAREN .param_list RPAREN') { |i, ps| [i, ps] }
	end

	p(:if_expr, 'IF expr_midlevel NEWLINE+ if_expr_prime') do |_, c, _, p|
		# Add the top-level conditional to the condition/sequence pairs.
		p[0][0] = c

		If.from_pairs p
	end

	p(:if_expr_prime) do
		c('.expr_sequence END')                                            { |es|                                     [[nil, es]] }
		c('.expr_sequence ELSE NEWLINE+ .expr_sequence END')               { |es0, es1|                  [[nil, es0], [nil, es1]] }
		c('.expr_sequence ELSE IF .expr_midlevel NEWLINE+ .if_expr_prime') { |es, c, ps| ps.tap { p[0][0] = c }.unshift [nil, es] }
	end

	p(:let_expr, 'LET let_expr_prime') { |_, vars| Let.new vars }

	p :let_expr_prime do
		c('.IDENT COLON .NSIDENT')                                { |i, t|                 [VarDecl.new(Type.new(t)), i] }
#		c('.IDENT LPAREN .arg_list RPAREN COLON .NSIDENT')        { |i, a, t|      [VarDecl.new(Type.new(t), i, nil, a] }
		c('.IDENT COMMA NEWLINE* .let_expr_prime')                { |i, vs|    vs.unshift VarDecl.new(vs.first.type, i) }
		c('.IDENT COLON .NSIDENT COMMA NEWLINE* .let_expr_prime') { |i, t, vs|   vs.unshift VarDecl.new(Type.new(t), i) }

#		c('.IDENT LPAREN .arg_list RPAREN COMMA NEWLINE* .let_expr_prime') do |i, a, vs|
#			[VarDecl.new vs.first.type, i, nil, a] + vs
#		end
#
#		c('.IDENT LPAREN .arg_list RPAREN COLON .NSIDENT COMMA NEWLINE* .let_expr_prime') do |i, a, t, vs|
#			[VarDecl.new Type.new(t), i, nil, a] + vs
#		end
	end

	p :literal do
		c('ATOM')    { |a| Atom.new     Type.new('Atom'),    a }
		c('FLOAT')   { |f| KFloat.new   Type.new('Float'),   f }
		c('INTEGER') { |i| KInteger.new Type.new('Integer'), i }
		c('STRING')  { |s| KString.new  Type.new('String'),  s }
	end

	p :param_ident do
		c('IDENT')      { |id| ParamDef.new nil, id }
		c('UNDERSCORE') { |_|  !Sink                }
	end

	p :param_list do
		c('NEWLINE*')                 { |_|            nil }
		c('NEWLINE* param_list_sub1') { |_, params| params }
	end

	p :param_list_sub1 do
#		c('.literal NEWLINE*')                                           { |l|                                            [l] }
#		c('.literal COMMA NEWLINE* .param_list_sub1')                    { |l, ps|                               ps.unshift l }

		c('.param_ident COLON .NSIDENT NEWLINE*')                        { |i, t|               [ParamDef.new Type.new(t), i] }
		c('.param_ident COLON .NSIDENT COMMA NEWLINE* .param_list_sub1') { |i, t, ps| ps.unshift ParamDef.new(Type.new(t), i) }

		c('.param_ident COMMA NEWLINE* .param_list_sub1') do |i, ps|
			ps.unshift ParamDef.new(ps.first.type, i)
		end

#		c('param_list_sub2') { |params| params }
	end

#	p :param_list_sub2 do
#		c('.IDENT LPAREN .arg_list RPAREN COLON .NSIDENT NEWLINE*') do |i, a, t|
#			[ParamDef.new Type.new(t), i, nil, a]
#		end
#
#		c('.IDENT LPAREN .arg_list RPAREN COLON .NSIDENT COMMA NEWLINE* .param_list_sub2', :array) do |i, a, t, ps|
#			[ParamDef.new Type.new(t), i, nil, a] + ps
#		end
#
#		c('.IDENT LPAREN .arg_list RPAREN COMMA NEWLINE* .param_list_sub2') do |i, a, ps|
#			[ParamDef.new ps.first.type, i, nil, a] + ps
#		end
#	end

	CACHE_FILE = File.expand_path('../parser.tbl', __FILE__)

	finalize explain: 'kalkin.automata'
end
