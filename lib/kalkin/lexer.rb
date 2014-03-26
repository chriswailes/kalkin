# Author:		Chris Wailes <chris.wailes@gmail.com>
# Project: 	Kalkin
# Date:		2014/03/26
# Description:	This file contains the lexer definition for Kalkin.

############
# Requires #
############

# RTLK
require 'rltk/lexer'

#######################
# Classes and Modules #
#######################

class Kalkin::Lexer < RLTK::Lexer
	
	############
	# Keywords #
	############
	
	rule(/class/)     { :CLASS     }
	rule(/def/)       { :DEF       }
	rule(/else/)      { :ELSE      }
	rule(/end/)       { :END       }
	rule(/if/)        { :IF        }
	rule(/let/)       { :LET       }
	rule(/namespace/) { :NAMESPACE }
	rule(/return/)    { :RETURN    }
	rule(/self/)      { :SELF      }
	
	###########################
	# Punctuation and Symbols #
	###########################
	
	rule(/->/) { :ARROW   }
	rule(/:/)  { :COLON   }
	rule(/,/)  { :COMMA   }
	rule(/\./) { :DOT     }
	rule(/\(/) { :LPAREN  }
	rule(/\n/) { :NEWLINE }
	rule(/"/)  { :QUOTE   }
	rule(/\)/) { :RPAREN  }
	
	############
	# Literals #
	############
	
	rule(/\d+/)      { |t| [:INTEGER, t.to_i }
	rule(/:[a-z_]+/) { |t| [:ATOM, t[1..-1]] }
	
	###############
	# Identifiers #
	###############
	
	
	
	############
	# Comments #
	############
	
	rule(/#/)                    { push_state :line_comment }
	rule(/\n/,    :line_comment) { pop_state }
	rule(/[^\n]/, :line_comment)
	
	rule(/#\*/)                 { push_state :block_comment }
	rule(/#\*/, :block_comment) { push_state :block_comment }
	rule(/\*#/, :block_comment) { pop_state                 }
	rule(/./,   :block_comment)
end
