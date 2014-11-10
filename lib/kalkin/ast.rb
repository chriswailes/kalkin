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
			value :ruby_val, Symbol
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
	end
end
