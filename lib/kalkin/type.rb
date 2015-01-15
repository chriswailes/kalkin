# Author:		Chris Wailes <chris.wailes@gmail.com>
# Project: 	Kalkin
# Date:		2014/04/05
# Description:	This file contains the base class for Kalkin types.

############
# Requires #
############

# Kalkin
require 'kalkin/ast'

#######################
# Classes and Modules #
#######################

module Kalkin
	class Type

	end

	class UnresolvedType < Type
		attr_reader :name

		def initialize(name)
			@name = name
		end

		def to_s
			@name
		end
	end

	class KlassType < Type
		attr_reader :klass

		def initialize(klass)
			@klass = klass
		end

		def to_s
			@klass.name
		end
	end
end
