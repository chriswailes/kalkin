# Author:      Chris Wailes <chris.wailes@gmail.com>
# Project:     Kalkin
# Date:        2014/03/25
# Description: This is the base file for Kalkin's LLVM backend.

module Kalkin
	module Backends
		module LLVM
			class << self
				def populate_namespace(ns)
					ns.add_members(Kalkin::AST::NodeList.new([
							Kalkin::AST::Klass.new('Atom'),
							Kalkin::AST::Klass.new('Bool'),
							Kalkin::AST::Klass.new('Integer'),
							Kalkin::AST::Klass.new('Float'),
							Kalkin::AST::Klass.new('String')
						]))
				end
			end
		end
	end
end
