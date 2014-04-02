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
	
	default_arg_type :array
	
#	right :NEWLINE
	
#	left  :PREFER_ALL
#	left  :PREFER_ALL_BUT_TUPLE
#	left  :PREFER_OPERATOR, :PREFER_MESSAGE, :PREFER_COMMA
#	left  :RPAREN
#	left  :OPERATOR
#	left  :PREFER_UNARY
#	right
#	right
#	right
#	right :COMMA
#	right :DOT, :MESSAGE

	p :input do
		c('NEWLINE* input_prime') { |_| nil }
	end
	
	p :input_prime do
		c('') { |_| nil }
		c('function_def') { |_| nil }
		c('function_def NEWLINE+ input_prime') { |_| nil }
	end
	
	p :expr do
		c('literal') { |_| nil }
		
		c('LPAREN expr RPAREN') { |_| nil }
	end
	
	p :expr_sequence do
		c('NEWLINE* expr_sequence_prime') { |_| nil }
	end
	
	p :expr_sequence_prime do
		c('') { |_| nil }
		c('expr NEWLINE+ expr_sequence_prime') { |_| nil }
	end
	
	p :function_def do
		c('function_sig ARROW literal') { |_| nil }
		c('function_sig COLON NSIDENT ARROW expr') { |_| nil }
		c('function_sig COLON NSIDENT NEWLINE expr_sequence END') { |_| nil }
	end
	
	p(:function_sig, 'DEF IDENT LPAREN param_list RPAREN') { |_| nil }
	
	p :literal do
		c('ATOM')    { |_| nil }
		c('FLOAT')   { |_| nil }
		c('INTEGER') { |_| nil }
		c('STRING')  { |_| nil }
	end
	
	p :param_list do
		c('') { |_| nil }
		c('param_list_sub1') { |_| nil }
	end
	
	p :param_list_sub1 do
		c('IDENT COLON NSIDENT') { |_| nil }
		c('IDENT LPAREN expr RPAREN COLON NSIDENT') { |_| nil }
		c('IDENT COMMA param_list_sub1') { |_| nil }
		c('IDENT COLON NSIDENT COMMA param_list_sub1') { |_| nil }
		c('IDENT LPAREN expr RPAREN COMMA param_list_sub2') { |_| nil }
		c('IDENT LPAREN expr RPAREN COLON NSIDENT COMMA param_list_sub2') { |_| nil }
	end
	
	p :param_list_sub2 do
		c('IDENT LPAREN expr RPAREN COLON NSIDENT') { |_| nil }
		c('IDENT LPAREN expr RPAREN COLON NSIDENT COMMA param_list_sub2')  { |_| nil }
		c('IDENT LPAREN expr RPAREN COMMA param_list_sub2') { |_| nil }
	end
	
	###################################################

	
#	p :var_decl do
#		c('var_decl_wo_default') { |_| nil }
#		c('var_decl_w_default')  { |_| nil }
#	end
#	
#	p :var_decl_wo_default do
#		c('IDENT') { |_| nil }
#		c('IDENT COLON NSIDENT') { |_| nil }
#	end
#	
#	p :var_decl_w_default do
#		c('IDENT LPAREN expr RPAREN') { |_| nil }
#		c('IDENT LPAREN expr RPAREN COLON NSIDENT') { |_| nil }
#	end
#
#	p(:nt_pair, 'IDENT COLON NSIDENT') { |_| nil }
#	
#	p(:param_list) do
#		c('')                     { |_| nil }
#		c('param_list_prime')     { |_| nil }
#		c('param_w_default_list') { |_| nil }
#	end
#	
#	p(:param_list_prime) do
#		c('nt_pair')                            { |_| nil }
#		c('UNDERSCORE')                         { |_| nil }
#		c('nt_pair COMMA NEWLINE* param_list_prime')     { |_| nil }
#		c('nt_pair COMMA NEWLINE* param_w_default_list') { |_| nil }
#	end
#	
#	p(:param_w_default_list) do
#		c('param_w_default_list_prime')                                     { |_| nil }
#		c('param_w_default_list_prime COMMA NEWLINE* param_w_default_list') { |_| nil }
#	end
#	
#	p(:param_w_default_list_prime) do
#		c('IDENT LPAREN literal RPAREN')               { |_| nil }
#		c('IDENT LPAREN literal RPAREN COLON NSIDENT') { |_| nil }
#	end
#	
#	p(:arg_list) do
#		c('') { |_| nil }
#		c('arg_list_prime') { |_| nil }
#	end
#	
#	p(:arg_list_prime) do
#		c('expr_line', :PREFER_COMMA) { |_| nil }
#		c('expr_line COMMA NEWLINE* arg_list') { |_| nil }
#	end
#	
#	p(:arg_list_line) do
#		c('', :PREFER_OPERATOR) { |_| nil }
#		c('arg_list_line_prime') { |_| nil }
#	end
#	
#	p(:arg_list_line_prime) do
#		c('expr_line', :PREFER_ALL_BUT_TUPLE) { |_| nil }
#		c('expr_line COMMA arg_list_line') { |_| nil }
#	end
#	
#	p(:expr) do
#		c('expr_line', :PREFER_OPERATOR) { |_| nil }
#		c('expr_prime', :PREFER_OPERATOR) { |_| nil }
#	end
#	
#	p(:expr_prime) do
#		c('LPAREN expr_prime RPAREN') { |_| nil }
#		
#		c('if_expr') { |_| nil }
#		
#		c('expr_prime OPERATOR NEWLINE+ expr') { |_| nil }
#		c('expr_prime DOT NEWLINE+ IDENT LPAREN arg_list RPAREN') { |_| nil }
#		c('expr_prime DOT NEWLINE+ IDENT OPERATOR EXPR') { |_| nil }
#		
#		c('IDENT ASSIGN NEWLINE+ expr') { |_| nil }
#		c('expr_prime DOT NEWLINE+ IDENT ASSIGN EXP') { |_| nil }
#	end
#	
#	p(:if_expr) do
#		c('if_expr_prime END') { |_| nil }
#		c('if_expr_prime ELSE NEWLINE expr NEWLINE END') { |_| nil }
#		c('if_expr_prime ELSE if_expr') { |_| nil }
#	end
#	
#	p(:if_expr_prime, 'IF expr_line NEWLINE expr NEWLINE') { |_| nil }
#	
#	p(:expr_line) do
#		c('literal') { |_| nil }
#		c('IDENT') { |_| nil }
#		c('LPAREN expr_line RPAREN', :PREFER_MESSAGE) { |_| nil }
#		
#		c('IF expr_line THEN expr_line ELSE expr_line END') { |_| nil }
#		c('IF expr_line THEN expr_line ELSE expr_line NEWLINE') { |_| nil }
#		
#		c('expr_line OPERATOR expr_line') { |_| nil }
#		c('expr_line DOT IDENT LPAREN arg_list_line RPAREN', :MESSAGE) { |_| nil }
#		c('expr_line DOT IDENT arg_list_line') { |_| nil }
#		c('expr_line DOT IDENT OPERATOR expr_line') { |_| nil }
#		
#		# Function call
#		c('expr_line LPAREN arg_list_line RPAREN') { |_| nil }
#		
#		# Constructor call
#		c('NSIDENT LPAREN arg_list_line RPAREN') { |_| nil }
#		
#		c('OPERATOR expr_line') { |_| nil }
#		
#		c('IDENT ASSIGN expr_line') { |_| nil }
#		c('expr_line DOT IDENT ASSIGN expr_line') { |_| nil }
#	end
#	
#	p(:function_body) do
#		c('NEWLINE function_body_sub1') { |_| nil }
#	end
#	
#	p(:function_body_sub1) do
#		c('NEWLINE') { |_| nil }
#		c('expr NEWLINE+ function_body_sub2') { |_| nil }
#		c('var_decl NEWLINE+ function_body_sub2') { |_| nil }
#	end
#	
#	p(:function_body_sub2) do
#		c('') { |_| nil }
#		c('expr NEWLINE+ function_body_sub2') { |_| nil }
#		c('var_decl NEWLINE+ function_body_sub2') { |_| nil }
#	end
#	
#	
#	
#	p(:literal) do
#		c('ATOM')    { |_| nil }
#		c('FLOAT')   { |_| nil }
#		c('INTEGER') { |_| nil }
#		c('STRING')  { |_| nil }
#		
#		c('LBRACKET tuple_body RBRACKET') { |_| nil }
#		
#		c('LPAREN   tuple_body RPAREN')   { |_| nil }
#	end
#	
#	# { |a, _, b| [a] + b }
#	p(:tuple_body, 'expr_line COMMA tuple_body_prime') { |_| nil }
#	
#	p(:tuple_body_prime) do
#		c('expr_line', :PREFER_ALL) { |_| nil }
#		c('expr_line COMMA tuple_body_prime') { |_| nil }
#	end
#	
#	p(:var_decl) do
#		c('LET nt_pair NEWLINE') { |_| nil }
#		c('LET nt_pair ASSIGN expr') { |_| nil }
#	end
	
	CACHE_FILE = File.expand_path('../parser.tbl', __FILE__)
	
	finalize explain: 'kalkin.automata'
end
