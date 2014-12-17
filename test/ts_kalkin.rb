# Author:		Chris Wailes <chris.wailes@gmail.com>
# Project: 	Kalkin
# Date:		2014/03/26
# Description:	This file contains the test suit for Kalkin.  It requires the
#			individual tests from their respective files.

############
# Requires #
############

# Filigree
require 'filigree/request_file'

request_file('simplecov', 'SimpleCov is not installed.') do
	SimpleCov.start do
		add_filter 'tc_*'
	end
end

# Test cases
require 'tc_isomorphism.rb'
require 'tc_namespace.rb'
