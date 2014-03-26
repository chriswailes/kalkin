# Author:		Chris Wailes <chris.wailes@gmail.com>
# Project: 	Kalkin
# Date:		2014/03/25
# Description:	This file sets up autoloads for the Kalkin::Passes module.

############
# Includes #
############

# Filigree
require 'filigree/request_file'

# The module contains AST transformation passes for the Kalkin compiler and
# language tools library.
module Kalkin::Passes
	available_passes = File.join(File.dirname(File.expand_path(__FILE__)), 'passes/*.rb')
	
	available_passes.each do |pass_file|
		request_file pass_file
	end
	
	# Return all available transformation passes.
	def all
		self.constants.map { |pass_name| self.const_get(pass_name, false) }
	end
	alias :list :all
end
