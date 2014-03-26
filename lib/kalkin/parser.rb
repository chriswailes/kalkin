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
	
	production('input') do
		
	end	
	
	production('expression') do
		
	end
	
	production('function_def') do
		
	end
	
	production('function_sig', 'DEF IDENT LPAREN param_list RPAREN') {}
	
	production('literal') do
		clause('ATOM')    {}
		clause('FLOAT')   {}
		clause('INTEGER') {}
		clause('STRING')  {}
	end
	
	production('nt_pair', 'IDENT COLON NSIDENT') {}
	
	production('param_list') do
		clause('')                     {}
		clause('param_list_prime')     {}
		clause('param_w_default_list') {}
	end
	
	production('param_list_prime') do
		clause('nt_pair')                            {}
		clause('nt_pair COMMA param_list_prime')     {}
		clause('nt_pair COMMA param_w_default_list') {}
	end
	
	production('param_w_default_list') do
		clause('nt_pair ASSIGN literal')                            {}
		clause('nt_pair ASSIGN literal COMMA param_w_default_list') {}
	end
	
	finalize explain: 'kalkin.automaton'
end
