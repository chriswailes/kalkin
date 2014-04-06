# Author:		Chris Wailes <chris.wailes@gmail.com>
# Project: 	Kalkin
# Date:		2014/04/05
# Description:	This file contains the base class for Kalkin types.

############
# Requires #
############

#######################
# Classes and Modules #
#######################

class Kalkin::UnresolvedType < Exception
	def to_s
		'Type has not been resolved.'
	end
end

class Kalkin::Type
	attr_accessor :resolved
	
	def initialize(name)
		@name     = name
		@kclass   = nil
		@resolved = false
	end
	
	def kclass
		@resolved ? @kclass : raise UnresolvedType
	end
	alias :'!' :kclass
	
	def name
		@resolved ? @kclass.name : @name
	end
	
	def resolve(kclass)
		@name     = nil
		@kclass   = kclass
		@resolved = true
	end
end
