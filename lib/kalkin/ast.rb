# Author:      Chris Wailes <chris.wailes@gmail.com>
# Project:     Kalkin
# Date:        2014/03/26
# Description: This file contains AST node definitions for Kalkin.

############
# Requires #
############

# Standard Library
require 'singleton'

# Filigree
require 'filigree/abstract_class'

# RLTK
require 'rltk/ast'

#######################
# Classes and Modules #
#######################

module Kalkin

	class UnknownNamespace < Exception; end

	module AST

		class Expression < RLTK::ASTNode
			# More later
		end

		class Literal < Expression
			def !
				self.ruby_val
			end
		end

		class KAtom < Literal
			value :ruby_val, String
		end

		class KBool < Literal
			value :ruby_val, Object
		end

		class KFloat < Literal
			value :ruby_val, Float
		end

		class KInteger < Literal
			value :ruby_val, Fixnum
		end

		class KString < Literal
			value :ruby_val, String
		end

		class If < Expression
			child :cond,  Expression
			child :then_, Expression
			child :else_, Expression
		end

		class Invocation < Expression
			value :name, String
		end

		class FunctionCall < Invocation
			child :args, [Expression]
		end

		class MessageSendBase < Invocation
			child :self_, Expression
		end

		class MessageSend < MessageSendBase
			child :args, [Expression]

			def operator?
				not (name[0,1] =~ /[a-z]/)
			end
		end

		class SplitMessageSend < MessageSend
			value :op, String

			def operator?
				true
			end
		end

		class UnaryMessageSend < MessageSendBase; end

		class UnresolvedSymbol < Expression
			value :name, String
		end
	end
end
