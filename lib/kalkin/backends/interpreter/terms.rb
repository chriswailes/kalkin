# Author:      Chris Wailes <chris.wailes@gmail.com>
# Project:     Kalkin
# Date:        2016/02/26
# Description: Term definitions for the Kalkin interpreter.

############
# Requires #
############

# Filigree
require 'filigree/types'

#######################
# Classes and Modules #
#######################

module Kalkin; module Backends; module Interpreter

class ObjectID
	def initialize(id)
		@id = id
	end
	
	def to_i
		@id
	end
	
	def to_s
		@id.to_s
	end
end

class Reference
	attr_reader :name

	def initialize(name)
		@name = name
	end
	
	def to_s
		@name
	end
end

class Name
	def initialize(name)
		@name = name
	end
end

class Namespace
	def initialize
		# Name => ObjectID
		@mapping = Hash.new
	end
end

class Environment
	def initialize
		# Reference => ObjectID
		@versions = Hash.new { |h, k| h[k] = -1}
		@mapping  = Hash.new
	end
	
	def add_reference(objID, name = '')
		version = (@versions[name] += 1)
		ref     = Reference.new(name + "!#{version}")
		
		@mapping[ref] = objID
		
		return ref
	end
	
	alias add_ref add_reference
	
	def get_objID(ref)
		@mapping[ref]
	end
	
	def to_s
		'{' + @mapping.to_a.map {|k, v| "#{k} => #{v}"}.join(', ') + '}'
	end
end

class KObject
	attr_reader :kmembers
	attr_reader :kmethods

	def initialize
		@kmembers = Environment.new
		@kmethods = Environment.new
	end
	
	def to_s
		"<members := #{@kmembers.to_s} ; methods := #{@kmethods.to_s}>"
	end
end

class KFunction < KObject
	def initialize
		# Expression
		@kbody = nil
		
		super
	end
end

class KString < KObject
	attr_reader :val
	
	def initialize(val)
		@val = val
		
		super()
	end
	
	def to_s
		"<members := #{@kmembers.to_s} ; methods := #{@kmethods.to_s} ; value := '#{@val}'>"
	end
end

class ObjectSpace
	def initialize(name = nil)
		# ObjectID => KObject
		@objects = Array.new
		@name    = name
	end
	
	def add_object(obj)
		ObjectID.new(@objects.size).tap {@objects << check_type(obj, KObject, 'obj')}
	end
	
	alias add add_object
	alias :<< add_object
	
	def get_object(objID)
		if (objID.to_i < @objects.size)
			@objects[objID.to_i]
		else
			nil
		end
	end
	
	alias get get_object
	
	def to_s
		str = ''
		
		if @name
			str += "Object Space : #{@name}\n\n"
		end
		
		@objects.each_with_index do |obj, index|
			str += "[#{index}] => #{obj.to_s}\n"
		end
		
		str += "\n"
		
		return str
	end
end

end end end
