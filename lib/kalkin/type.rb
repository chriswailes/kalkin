# Author:		Chris Wailes <chris.wailes@gmail.com>
# Project: 	Kalkin
# Date:		2014/04/05
# Description:	This file contains the base class for Kalkin types.

############
# Requires #
############

# Filigree
require 'filigree/match'

# Kalkin
require 'kalkin/ast'

#######################
# Classes and Modules #
#######################

module Kalkin
	class Type
		include Filigree::Destructurable
	end

	class UnresolvedType < Type
		attr_reader :name

		def destructure(_)
			[@name]
		end

		def initialize(name)
			@name = name
		end

		def to_s
			@name
		end
	end

	class KlassType < Type
		attr_reader :klass

		@instances = Hash.new

		def self.new(klass)
			if @instances.has_key?(klass)
				@instances[klass]
			else
				@instances[klass] = super(klass)
			end
		end

		def destructure(_)
			[@klass]
		end

		def initialize(klass)
			@klass = klass
		end

		def to_s
			@klass.name
		end
	end
end
