# Author:		Chris Wailes <chris.wailes@gmail.com>
# Project: 	Kalkin
# Date:		2014/03/26
# Description:	This file contains the symbol table for the Kalkin compiler.

############
# Requires #
############

require 'kalkin/ast'

#######################
# Classes and Modules #
#######################
module Kalkin
	class SymbolTable

		include Kalkin::AST

		def initialize
			# Initialize our frames with the global frame.
			@frames = [{}]
		end

		def add_frame
			@frames.unshift(Hash.new)
		end

		def use(sym)
			refbind =
			@frames.inject(nil) {|_, frame| if frame.key?(sym) then break frame[sym] else nil end}

			if refbind then RefUse.new(refbind) else UnresolvedSymbol.new(sym) end
		end

		def bind(sym, type)
			@frames.first[sym] = ParamRefBind.new(sym, type)
		end

		def drop_frame
			@frames.shift
		end
	end
end
