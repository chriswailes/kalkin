# Author:		Chris Wailes <chris.wailes@gmail.com>
# Project: 	Kalkin
# Date:		2014/03/25
# Description:	This file sets up autoloads for the Kalkin module.

# The internal module for the Kalkin compiler and language tools library.
module Kalkin
	autoload :AST,         'kalkin/ast'
	autoload :Backends,    'kalkin/backends'
	autoload :Lexer,       'kalkin/lexer'
	autoload :Parser,      'kalkin/parser'
	autoload :Pass,        'kalkin/pass'
	autoload :Passes,      'kalkin/passes'
	autoload :PassManager, 'kalkin/pass_manager'
	autoload :KSymbol,     'kalkin/symbol'
	autoload :SymbolTable, 'kalkin/symbol_table'
#	autoload :Type,        'kalkin/type'
	autoload :VERSION,     'kalkin/version'
end
