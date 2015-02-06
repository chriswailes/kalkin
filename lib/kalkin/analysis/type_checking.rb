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

			####################
			# Helper Functions #
			####################

			# @param [UnresolvedType]  ut  Type to resolve
			def get_type(ut)
				klass = @tlns.find(Klass) { |n| n.name == ut.name }

				# TODO: Add proper error handling.
				klass ? KlassType.new(klass) : nil
			end

			############
			# Patterns #
			############

			on ExprSequence.(es, nil),
			   -> { es.last.type.is_a?(KlassType) } do |node|
				node.type = es.last.type
			end

			on Function.(_, ps, _, UnresolvedFunctionType.as(ut)),
			   -> { ps.empty? || ps.first.type.is_a?(ResolvedType) } do |node|

				node.type = FunctionType.new(ps.map(&:type), get_type(ut))
			end

			on Literal.(_, UnresolvedType.as(ut)) do |node|
				node.type = get_type(ut)
			end

			on RefBind.(_, UnresolvedType.as(ut)) do |node|
				node.type = get_type(ut)
			end
		end
	end
end
