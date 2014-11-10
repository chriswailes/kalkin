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
	class UnknownVariable < Exception
		def initialize(sym)
			super "Unknown variable: #{sym}"
		end
	end

	class SymbolTable
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

			if refbind then RefUse.new(refbind) else raise UnknownVariable.new(sym) end
		end

		def bind(sym, type = nil, init_val = nil)
			@frames.first[sym] = RefBinding.new(sym, type, init_val)
		end

		def drop_frame
			@frames.shift
		end
	end
end
