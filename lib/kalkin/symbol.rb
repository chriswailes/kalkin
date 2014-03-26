# Author:		Chris Wailes <chris.wailes@gmail.com>
# Project: 	Kalkin
# Date:		2014/03/26
# Description:	This file contains classes representing Symbols in the Kalkin
#              language.

############
# Requires #
############

require 'filigree/abstract_class'

#######################
# Classes and Modules #
#######################

module Kalkin
	class Symbol
		extend Filigree::AbstractClass
	end
	
	class TextualSymbol < Symbol
	
	end
	
	class InternalSymbol < Symbol
	
	end
end
