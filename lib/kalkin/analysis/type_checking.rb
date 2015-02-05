# Author:      Chris Wailes <chris.wailes@gmail.com>
# Project:     Kalkin
# Date:        2015/01/16
# Description: Basic type checking for Kalkin.

############
# Includes #
############

# Filigree
require 'filigree/visitor'

# Kalkin
require 'kalkin/ast'

#######################
# Classes and Modules #
#######################

module Kalkin
	module Analysis
		class TypeChecker
			include Kalkin::AST

			include Filigree::Visitor

			def initialize(tlns)
				@tlns = tlns
			end

			on Function.(_, _, _, unresolved_type) do |node|
				klass = @tlns.members.find { |n| n.is_a?(Klass) && n.name == unresolved_type.name }

				node.type = KlassType.new(klass) if klass
			end

			on RefBind.(_, unresolved_type) do |node|
				klass = @tlns.members.find { |n| n.is_a?(Klass) && n.name == unresolved_type.name }

				# TODO: Add proper error handling.
				node.type = KlassType.new(klass) if klass
			end

			on KNode do |node|
				node.children.flatten.each { |c| visit c }
			end
		end
	end
end
