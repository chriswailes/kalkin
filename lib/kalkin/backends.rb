# Author:		Chris Wailes <chris.wailes@gmail.com>
# Project: 	Kalkin
# Date:		2014/03/25
# Description:	This file sets up autoloads for the Kalkin::Backends module.

# The module contains code generating backends for the Kalkin compiler.
module Kalkin::Backends
	autoload :LLVM, 'kalkin/backends/llvm'
end
