# Author:      Chris Wailes <chris.wailes@gmail.com>
# Project:     Kalkin
# Date:        2017/09/03
# Description: Classes and functions for communicating with users of the Kalkin
#              infrastructure.

############
# Requires #
############

# Standard Library

# Project

#######################
# Classes and Modules #
#######################

module Kalkin
	class UserMessages
		attr_accessor :info, :warnings, :errors

		def initialized
			@info     = Array.new
			@warnings = Array.new
			@errors   = Array.new
		end
	end
end
