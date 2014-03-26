# Author:		Chris Wailes <chris.wailes@gmail.com>
# Project: 	Kalkin
# Date:		2014/03/25
# Description:	This file sets up autoloads for the Kalkin module.

# The internal module for the Kalkin compiler and language tools library.
module Kalkin::Backends::LLVM
	autoload :Codegen,   'kalkin/backends/llvm/codegen'
	autoload :Namespace, 'kalkin/backends/llvm/namespace'
end
