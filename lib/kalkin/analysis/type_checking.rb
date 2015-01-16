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

########
# Code #
########

module Kalkin
	module Analysis
		class TypeChecker < Filigree::Visitor
			def initialize(tlns)
				@tlns = tlns
			end

			on RefBind.(_, unresolved_type) do |node|
				resolved_type = @tlns.find_type(unresolved_type.name)

				# TODO: Add proper error handling.
				node.type = resolved_type if resolved_type
			end

			on KNode do |node|
				node.children.each { |c| visit c }
			end
		end
	end
end
