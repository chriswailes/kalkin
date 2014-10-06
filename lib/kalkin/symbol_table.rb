# Author:		Chris Wailes <chris.wailes@gmail.com>
# Project: 	Kalkin
# Date:		2014/03/26
# Description:	This file contains the symbol table for the Kalkin compiler.

############
# Requires #
############

#######################
# Classes and Modules #
#######################
module Kalkin
	class SymbolTableException < Exception
		attr_reader :symbol

		def initialize(symbol)
			@symbol = symbol
		end

		def to_s
			"#{@@error_string}: #{@symbol_name}"
		end
	end

	class RedefinedSymbol < SymbolTableException
		@@error_string = 'Redefinition of symbol'
	end

	class UndefinedSymbol < SymbolTableException
		@@error_string = 'Undefined symbol'
	end

	class SymbolTable
		# @param [Namespace]  scope
		def initialize(scope)
			@scope = scope
			# Hash{String => Fixnum}
			@symbols = Hash.new
		end

		def define_symbol(symbol_name)
			if not @symbols.key?(symbol_name)
				@symbols[string] = [KSymbol.new(symbol_name, 0)]
			else
				raise RedefinedSymbol, symbol_name
			end
		end
		alias :'<<' :define_symbol

		def exists?(symbol_name)
			@symbols.key?(symbol_name)
		end

		def get_symbol(symbol_name)
			if @symbols.key?(symbol_name)
				@symbols[symbol_name].last
			else
				raise UndefinedSymbol, symbol_name
			end
		end
		alias :'[]' :get_symbol

		def increment_version(symbol)
			if @symbol.key(symbol_name = symbol.name)
				@symbols[symbol_name] << +symbol
			else
				raise UndefinedSymbol, symbol
			end
		end
	end
end
