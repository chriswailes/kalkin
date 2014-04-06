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
	
	p(:expr_sequence, 'NEWLINE* expr_sequence_prime') { |_| nil }
	
	p :expr_sequence_prime do
		c('') { |_| nil }
		c('expr_toplevel NEWLINE+ expr_sequence_prime') { |_| nil }
	end
	
	p :function_def do
		c('function_sig ARROW literal') { |_| nil }
		c('function_sig COLON NSIDENT ARROW expr_toplevel') { |_| nil }
		c('function_sig COLON NSIDENT NEWLINE expr_sequence END') { |_| nil }
	end
	
	p :function_sig do
		c('DEF IDENT') { |_| nil }
		c('DEF IDENT LPAREN param_list RPAREN') { |_| nil }
	end
	
	p(:if_expr, 'IF expr_midlevel NEWLINE+ if_expr_prime') { |_| nil }
	
	p(:if_expr_prime) do
		c('expr_sequence ELSE NEWLINE+ expr_sequence END') { |_| nil }
		c('expr_sequence ELSE IF expr_midlevel NEWLINE+ if_expr_prime') { |_| nil }
		c('expr_sequence END') { |_| nil }
	end
	
	p(:let_expr, 'LET let_expr_prime') { |_| nil }
	
	p :let_expr_prime do
		c('IDENT COLON NSIDENT') { |_| nil }
		c('IDENT LPAREN expr_core RPAREN COLON NSIDENT') { |_| nil }
		c('IDENT COMMA NEWLINE* let_expr_prime') { |_| nil }
		c('IDENT LPAREN expr_core RPAREN COMMA NEWLINE* let_expr_prime') { |_| nil }
		c('IDENT COLON NSIDENT COMMA NEWLINE* let_expr_prime') { |_| nil }
		c('IDENT LPAREN expr_core RPAREN COLON NSIDENT COMMA NEWLINE* let_expr_prime') { |_| nil }
	end
	
	p :literal do
		c('ATOM')    { |_| nil }
		c('FLOAT')   { |_| nil }
		c('INTEGER') { |_| nil }
		c('STRING')  { |_| nil }
	end
	
	p :param_ident do
		c('IDENT') { |_| nil }
		c('UNDERSCORE') { |_| nil }
	end
	
	p :param_list do
		c('NEWLINE*') { |_| nil }
		c('NEWLINE* param_list_sub1') { |_| nil }
	end
	
	p :param_list_sub1 do
		c('literal NEWLINE*') { |_| nil }
		c('literal COMMA NEWLINE* param_list_sub1') { |_| nil }
		c('param_ident COLON NSIDENT NEWLINE*') { |_| nil }
		c('param_ident COLON NSIDENT COMMA NEWLINE* param_list_sub1') { |_| nil }
		c('param_ident COMMA NEWLINE* param_list_sub1') { |_| nil }
		c('param_list_sub2') { |_| nil }
	end
	
	p :param_list_sub2 do
		c('IDENT LPAREN expr_core RPAREN COLON NSIDENT NEWLINE*') { |_| nil }
		c('IDENT LPAREN expr_core RPAREN COLON NSIDENT COMMA NEWLINE* param_list_sub2')  { |_| nil }
		c('IDENT LPAREN expr_core RPAREN COMMA NEWLINE* param_list_sub2') { |_| nil }
	end
	
	CACHE_FILE = File.expand_path('../parser.tbl', __FILE__)
	
	finalize explain: 'kalkin.automata'
end
