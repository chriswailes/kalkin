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

	p(:input, 'NEWLINE* input_prime') { |_| nil }
	
	p :input_prime do
		c('') { |_| nil }
		c('function_def') { |_| nil }
		c('function_def NEWLINE+ input_prime') { |_| nil }
	end
	
	p :arg_list do
		c('NEWLINE*') { |_| nil }
		c('NEWLINE* arg_list_prime') { |_| nil }
	end
	
	p :arg_list_prime do
		c('expr_core NEWLINE*') { |_| nil }
		c('expr_core COMMA NEWLINE* arg_list_prime') { |_| nil }
	end
	
	p :expr_toplevel do
		c('expr_midlevel') { |_| nil }
		c('if_expr') { |_| nil }
	end
	
	p :expr_midlevel do
		c('expr_core') { |_| nil }
		c('let_expr') { |_| nil }
	end
	
	p :expr_core do
		c('literal') { |_| nil }
		c('LPAREN expr_core RPAREN') { |_| nil }
		
		# Single-line if-expr
		c('IF expr_midlevel THEN expr_core ELSE expr_core END') { |_| nil }
		
		# Function call
		c('IDENT LPAREN arg_list RPAREN') { |_| nil }
		
		# Method call
		c('expr_core DOT NEWLINE* IDENT LPAREN arg_list RPAREN') { |_| nil }
		c('expr_core DOT NEWLINE* IDENT') { |_| nil }
		
		# Operator call
		c('expr_core OPERATOR NEWLINE* expr_core') { |_| nil }
		c('OPERATOR expr_core') { |_| nil }
		
		# Method/Operator Call
		c('expr_core DOT NEWLINE* IDENT OPERATOR NEWLINE* expr_core') { |_| nil }
	end
	
	p(:expr_sequence, 'NEWLINE* expr_sequence_prime') { |_, es| ExprSequence.new es }
	
	p :expr_sequence_prime do
		c('')                                           { |_|              [] }
		c('expr_toplevel NEWLINE+ expr_sequence_prime') { |e, _, es| [e] + es }
	end
	
	p :function_def do
		c('function_sig ARROW literal') do |sig, _, l|
			name, params = sig
			Function.new name, [], l.type, params, ExprSequence.new([l])
		end
		
		c('function_sig COLON NSIDENT ARROW expr_toplevel') do |sig, _, t, _, e|
			name, params = sig
			Function.new name, [], Type.new(t), params, ExprSequence.new([e])
		end
		
		c('function_sig COLON NSIDENT NEWLINE expr_sequence END') do |sig, _, t, _, es, _|
			name, params = sig
			Function.new name, [], Type.new(t), params, es
		end
	end
	
	p :function_sig do
		c('DEF IDENT')                          { |_, i|           [i, []] }
		c('DEF IDENT LPAREN param_list RPAREN') { |_, i, _, ps, _| [i, ps] }
	end
	
	p(:if_expr, 'IF expr_midlevel NEWLINE+ if_expr_prime') do |_, c, _, p|
		# Add the top-level conditional to the condition/sequence pairs.
		p[0][0] = c
		
		If.from_pairs p
	end
	
	p(:if_expr_prime) do
		c('expr_sequence END')                                          { |es, _|                                     [[nil, es]] }
		c('expr_sequence ELSE NEWLINE+ expr_sequence END')              { |es0, _, _, es1, _|            [[nil, es0], [nil, es1]] }
		c('expr_sequence ELSE IF expr_midlevel NEWLINE+ if_expr_prime') { |es, _, c, _, p|    [[nil, es]] + p.tap { p[0][0] = c } }
	end
	
	p(:let_expr, 'LET let_expr_prime') { |_, vars| Let.new vars }
	
	p :let_expr_prime do
		c('IDENT COLON NSIDENT')                               { |i, _, t|                  [VarDecl.new Type.new(t), i] }
#		c('IDENT LPAREN arg_list RPAREN COLON NSIDENT')        { |i, _, a, _, _, t| [VarDecl.new Type.new(t), i, nil, a] }
		c('IDENT COMMA NEWLINE* let_expr_prime')               { |i, _, _, vs|       [VarDecl.new vs.first.type, i] + vs }
		c('IDENT COLON NSIDENT COMMA NEWLINE* let_expr_prime') { |i, _, t, _, _, vs|   [VarDecl.new Type.new(t), i] + vs }
		
#		c('IDENT LPAREN arg_list RPAREN COMMA NEWLINE* let_expr_prime') do |i, _, a, _, _, _, vs|
#			[VarDecl.new vs.first.type, i, nil, a] + vs
#		end
#		
#		c('IDENT LPAREN arg_list RPAREN COLON NSIDENT COMMA NEWLINE* let_expr_prime') do |i, _, a, _, _, t, _, _, vs|
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
#		c('literal NEWLINE*')                                         { |l, _|                                           [l] }
#		c('literal COMMA NEWLINE* param_list_sub1')                   { |l, _, _, p|                           [a[0]] + a[3] }
		
		c('param_ident COLON NSIDENT NEWLINE*')                       { |i, _, t, _|           [ParamDef.new Type.new(t), i] }
		c('param_ident COLON NSIDENT COMMA NEWLINE* param_list_sub1') { |i, _, t, _, _, p| [ParamDef.new Type.new(t), i] + p }
		
		c('param_ident COMMA NEWLINE* param_list_sub1') do |i, _, _, ps|
			[ParamDef.new ps.first.type, i] + ps
		end
		
#		c('param_list_sub2') { |params| params }
	end
	
#	p :param_list_sub2 do
#		c('IDENT LPAREN arg_list RPAREN COLON NSIDENT NEWLINE*') do |i, _ a, _, _, t, _|
#			[ParamDef.new Type.new(t), i, nil, a]
#		end
#		
#		c('IDENT LPAREN arg_list RPAREN COLON NSIDENT COMMA NEWLINE* param_list_sub2', :array) do |i, _, a, _, _, t, _, _, ps|
#			[ParamDef.new Type.new(t), i, nil, a] + ps
#		end
#		
#		c('IDENT LPAREN arg_list RPAREN COMMA NEWLINE* param_list_sub2') do |i, _, a, _, _, _ ps|
#			[ParamDef.new ps.first.type, i, nil, a] + ps
#		end
#	end
	
	CACHE_FILE = File.expand_path('../parser.tbl', __FILE__)
	
	finalize explain: 'kalkin.automata'
end
