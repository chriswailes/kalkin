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

		class KNode < RLTK::ASTNode
			init_order :def
		end

		class Expression < KNode
			value :type, Type, true
		end

		class ArgList < KNode
			child :args, [Expression]

			# Init: args
			# Destructure: args

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

			# Init: exprs
			# Destructure: exprs

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
			def ~
				self.ruby_val
			end
		end

		class KAtom < Literal
			value :ruby_val, String

			# Init: ruby_val
			# Destructure: type, ruby_val
		end

		class KBool < Literal
			value :ruby_val, Object

			# Init: ruby_val
			# Destructure: type, ruby_val
		end

		class KFloat < Literal
			value :ruby_val, Float

			# Init: ruby_val
			# Destructure: type, ruby_val
		end

		class KInteger < Literal
			value :ruby_val, Fixnum

			# Init: ruby_val
			# Destructure: type, ruby_val
		end

		class KString < Literal
			value :ruby_val, String

			# Init: ruby_val
			# Destructure: type, ruby_val
		end

		class If < Expression
			child :cond,  Expression
			child :then_, Expression
			child :else_, Expression

			# Init: cond, then_, else_
			# Destructure: type, cond, then_, else_
		end

		class Invocation < Expression
			value :name, String

			# Init: name
			# Destructure: type, name
		end

		class FunctionCall < Invocation
			child :args, ArgList

			# Init: name, args
			# Destructure: type, name, args
		end

		class MessageSendBase < Invocation
			child :self_, Expression

			# Init: name, self_
			# Destructure: type, name, self_
		end

		class MessageSend < MessageSendBase
			child :args, ArgList

			# Init: name, self_, args
			# Destructure: type, name, self_, args

			def operator?
				not (name[0,1] =~ /[a-z]/)
			end
		end

		class SplitMessageSend < MessageSend
			value :op, String

			# Init: name, self_, args, op
			# Destructure: type, name, op, self_, args

			def operator?
				true
			end
		end

		class UnaryMessageSend < MessageSendBase; end

		class UnresolvedSymbol < Expression
			value :name, String

			# Init: name
			# Destructure: type, name
		end

		class RefBind < Expression
			value :name, String

			# Init: name
			# Destructure: type, name

			def initialize(name, type)
				super(name)

				self.type = type

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

			# Init: bind
			# Destructure: type, bind
		end

		class ParamList < KNode
			child :params, [ParamRefBind]

			# Init: params
			# Destructure: params

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
			value :type,       Type
			child :parameters, ParamList

			# Init: name, type, parameters
			# Destructure: name, type, parameters

			alias :params    :parameters
			alias :'params=' :'parameters='
		end

		class Function < Invokable
			child :body, ExprSequence

			# Init: name, type, parameters, body
			# Destructure: name, type, parameters, body
		end

		class NativeFunction < Invokable
			value :generator, Proc

			# Init: name, type, parameters, generator
			# Destructure: name, type, parameters, generator
		end

		class NodeList < KNode
			child :nodes, [KNode]

			# Init: nodes
			# Destructure: nodes

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

			# Init: name, members
			# Destructure: name, members

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

			# Init: name
			# Destructure: name
		end
	end
end
