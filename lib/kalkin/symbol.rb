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
	class KSymbol
		extend Filigree::AbstractClass
		
		# @returns [String]
		attr_reader :name
		# @returns [Fixnum]
		attr_reader :version
		# @returns [Namespace]
		attr_reader :scope
		
		alias :to_s :name
		
		# @param [String]    name
		# @param [Fixnum]    version
		# @param [Namespace] scope
		def initialize(name, version, scope)
			@name, @version, @scope = name, version, scope
		end
		
		def ==(other)
			self.class   == other.class   &&
			self.name    == other.name    &&
			self.version == other.version &&
			self.scope   == other.scope
		end
		
		def increment
			self.class.new(@name, @version + 1, @scope)
		end
		alias :'+@' :increment
	end
	
	class TextualSymbol  < KSymbol; end
	class InternalSymbol < KSymbol; end
end
