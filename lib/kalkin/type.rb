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
	attr_reader :name
	attr_reader :kclass
	
	# @param [String]  name
	def initialize(name)
		@name     = name
		@kclass   = nil
		@resolved = false
	end
	
	def ==(other)
		self.class == other.class &&
		self.name  == other.name
	end
	
	def ===(other)
		self.object_id == other.object_id
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
	
	def resolved?
		@resolved
	end
end
