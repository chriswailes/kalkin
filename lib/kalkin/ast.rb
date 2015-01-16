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

# Kalkin
require 'kalkin/type'

#######################
# Classes and Modules #
#######################

module Kalkin

	class UnknownNamespace < Exception; end

	module AST

		class KNode < RLTK::ASTNode; end

		class Expression < KNode
			# More later
		end

		class ArgList < KNode
			child :args, [Expression]

			def each(&block)
				self.args.each &block
			end

			def empty?
				self.args.empty?
			end

			def first
				self.args.first
			end

			def last
				self.args.last
			end
		end

		class ExprSequence < Expression
			child :exprs, [Expression]

			def each(&block)
				self.exprs.each &block
			end

			def empty?
				self.exprs.empty?
			end

			def first
				self.exprs.first
			end

			def last
				self.exprs.last
			end
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
			child :args, ArgList
		end

		class MessageSendBase < Invocation
			child :self_, Expression
		end

		class MessageSend < MessageSendBase
			child :args, ArgList

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

		class RefBind < Expression
			value :name, String
			value :type, Type

			def initialize(*args)
				super(*args)

				@elide_type = false
			end

			def elide_type
				self.tap { @elide_type = true }
			end

			def elide_type?
				@elide_type
			end
		end

		class ParamRefBind < RefBind; end

		class RefUse < Expression
			value :bind, RefBind
		end

		class ParamList < KNode
			child :params, [ParamRefBind]

			def each(&block)
				self.params.each &block
			end

			def empty?
				self.params.empty?
			end

			def first
				self.params.first
			end

			def last
				self.params.last
			end
		end

		class Invokable < KNode
			value :name,       String
			value :type,       String
			child :parameters, ParamList

			alias :params    :parameters
			alias :'params=' :'parameters='
		end

		class Function < Invokable
			child :body, ExprSequence
		end

		class NativeFunction < Invokable
			value :generator, Proc
		end

		class NodeList < KNode
			child :nodes, [KNode]

			def each(&block)
				self.nodes.each &block
			end

			def empty?
				self.nodes.empty?
			end

			def first
				self.nodes.first
			end

			def last
				self.nodes.last
			end
		end

		class Namespace < KNode
			value :name, String
			child :members, [KNode]

			def add_members(node_list)
				self.members += node_list.nodes
			end

			def get_members(node_type = nil)
				if node_type
					self.members.select { |n| n.is_a? node_type }
				else
					self.members
				end
			end
		end

		class Klass < KNode
			value :name, String
		end
	end
end
