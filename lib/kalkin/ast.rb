# Author:		Chris Wailes <chris.wailes@gmail.com>
# Project: 	Kalkin
# Date:		2014/03/26
# Description:	This file contains AST node definitions for Kalkin.

############
# Requires #
############

# Filigree
require 'filigree/abstract_class'

# RLTK
require 'rltk/ast'

#######################
# Classes and Modules #
#######################

class Kalkin::UnknownNamespace < Exception; end

module Kalkin::AST
	
	class Expression < RLTK::ASTNode
		extend Filigree::AbstractClass
		
		value :type, Type
	end
	
	class ExprSequence < Expression
		child :exprs, [Expression]
		
		def each(&block)
			self.exprs.each &block
		end
		
		def first
			self.exprs.first
		end
		
		def last
			self.exprs.last
		end
	end
	
	class Literal < Expression
		extend AbstractClass
		
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
	
	class Definition < Expression
		extend Filigree::AbstractClass
		
		value :name,   String
		value :symbol, KSymbol
	end
	
	class VarDef   < Definition; end
	class ParamDef < VarDef;     end
	
	class Invocation < Expression
		value :name, String
		
		child :args, [Expression]
	end
	
	class FunctionCall < Invocation; end
	class MessageSend  < Invocation; end
	
	class If < Expression
		child :cond,  Expression
		child :then_, ExprSequence
		child :else_, ExprSequence
	end
	
	class Let < Expression
		child :vars, [VarDef]
	end
	
	class Reference < Expression
		extend Filigree::AbstractClass
		
		value :name, String
		
		def !
			self.ref
		end
	end
	
	class VarRef < Reference
		value :symbol, KSymbol
	end
	
	class ParamRef < VarRef; end
	
	class NamespaceRef < Reference
		value :ref, Namespace
	end
	
	class InterfaceRef < NamespaceRef
		value :ref, Interface
	end
	
	class TraitRef < InterfaceRef
		value :ref, Trait
	end
	
	class KClassRef < TraitRef
		value :ref, KClass
	end
	
	class Namespace < RLTK::ASTNode
		value :name, String
		
		child :subspaces, [Namespace]
		
		def initialize(*_)
			super
			
			@symbols    = SymbolTable.new(self)
			@symbol_map = Hash.new
		end
		
		# @param [String]  symbol_name
		def define_symbol(symbol_name)
			@symbols << string
		end
		
		# FIXME Implement support for nested namespaces
		def get_namespace(namespace_name)
			get_subspace(namespace_name)
		end
		
		def get_subspace(subspace_name)
			if @symbol_map.key?(subspace_name)
				@symbol_map[subspace_name]
			elsif subspace = self.subspaces.find { |ns| ns.name == subspace_name }
				@symbol_map[subspace_name] = subspace
			else
				raise UnknownNamespace
			end
		end
		
		def get_symbol(symbol_name)
			if @symbols.exists?(symbol_name)
				@symbols[symbol_name]
			else
				self.parent.get_symbol(symbol_name)
			end
		end
		
		def increment_version(symbol)
			@symbols.increment_version(symbol)
		end
	end
	
	class Invocable < Namespace
		extend Filigree::AbstractClass
		
		value :ret_type, Type
		
		children :parameters, [ParamDef]
		children :body,       ExprSequence
		
		alias :params    :parameters
		alias :'params=' :'paramteters='
	end
	
	class Function < Invocable; end
	class Method   < Invocable; end
	
	class Interface < Namespace; end
	class Trait     < Interface; end
	class KClass    < Trait;     end
	
	class NativeFunction < Function; end
	class NativeMethod   < Method;   end
end
