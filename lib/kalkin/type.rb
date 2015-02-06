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

	class UnresolvedFunctionType < UnresolvedType; end

	class ResolvedType < Type; end

	class KlassType < ResolvedType
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

	class FunctionType < ResolvedType
		attr_reader :param_types
		attr_reader :ret_type

		def destructure(_)
			[@param_types, @ret_type]
		end

		def initialize(param_types, ret_type)
			@param_types = param_types
			@ret_type    = ret_type
		end

		def to_s
			"(#{(@param_types + [@ret_type]).join(' -> ')})"
		end
	end
end
