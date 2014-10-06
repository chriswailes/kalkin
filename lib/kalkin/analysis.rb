# Author:		Chris Wailes <chris.wailes@gmail.com>
# Project: 	Kalkin
# Date:		2014/03/256
# Description:	This file sets up autoloads for the Kalkin::Analysis module.

############
# Includes #
############

# Filigree
require 'filigree/request_file'

# The module contains AST analysis passes for the Kalkin compiler and language
# tools library.
module Kalkin::Analysis
	available_passes = File.expand_path('../analysis/*.rb', __FILE__)

	available_passes.each do |pass_file|
		request_file pass_file
	end

	# Return all available analysis passes.
	def all
		self.constants.map { |pass_name| self.const_get(pass_name, false) }
	end
	alias :list :all
end
