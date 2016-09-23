# Author:      Chris Wailes <chris.wailes@gmail.com>
# Project:     Kalkin
# Date:        2016/02/26
# Description: Eden state definitions for the Kalkin interpreter.

############
# Requires #
############

# Filigree

# Kalkin
require 'kalkin/backends/interpreter/terms'

#######################
# Classes and Modules #
#######################

module Kalkin; module Backends; module Interpreter

class ObjectHelper
	attr_reader :object_space
	
	def initialize(objspace)
		@os = objspace
	end
	
	def define_class(name)
		kclass_name_obj_id = @os.add(KString.new(name))
	
		kclass        = KObject.new
		kclass_obj_id = @os.add(kclass)
	
		kclass.kmembers.add_ref(kclass_name_obj_id, 'name')
		kclass.kmembers.add_ref(kclass_obj_id, 'self')
		
		return kclass_obj_id
	end
	
	def set_type(kclass_obj_id, ktype_obj_id)
		kclass = @os.get(kclass_obj_id)
		kclass.kmembers.add_ref(ktype_obj_id, 'type')
	end
end

def make_eden
	eden   = ObjectSpace.new("Eden")
	helper = ObjectHelper.new(eden)
	
	kobj_class_id   = helper.define_class('Object')
	kclass_class_id = helper.define_class('Class')
	
	helper.set_type(kobj_class_id, kclass_class_id)
	helper.set_type(kclass_class_id, kclass_class_id)
	
	return eden
end

end; end; end
