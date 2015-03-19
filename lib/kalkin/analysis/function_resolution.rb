# Author:      Chris Wailes <chris.wailes@gmail.com>
# Project:     Kalkin
# Date:        2015/02/06
# Description: Basic function resolution for Kalkin.

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
		class FunctionResolver
			include Kalkin::AST

			include Filigree::Visitor

			def initialize(tlns)
				@tlns = tlns
			end

			####################
			# Helper Functions #
			####################



			############
			# Patterns #
			############

			on FunctionCall.(~:name, ~:args, nil) do |node|
				puts "Found function call that needs to be resolved: #{node.name}"

				puts "Found #{@tlns.select(Function) { |n| n.name == name }.length} possible functions."
			end
		end
	end
end
