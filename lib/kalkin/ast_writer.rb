# Author:      Chris Wailes <chris.wailes@gmail.com>
# Project:     Kalkin
# Date:        2014/11/09
# Description: This file contains a pretty-printer for the Kalkin AST.

############
# Requires #
############

require 'pp'

# Filigree
require 'filigree/visitor'

# Project
require 'kalkin/ast'

#######################
# Classes and Modules #
#######################

module Kalkin

	class ASTWriter
		include Kalkin::AST

		include Filigree::Visitor

		on FunctionCall.(n, a) do |node|
			"#{n}(#{a.map {|n| visit n}.join(', ')})"
		end

		on If.(c, t, e) do
			"if #{visit c} then #{visit t} else #{visit e} end"
		end

		on KAtom.(a) do
			a.to_s
		end

		on KFloat.(f) do
			f.to_s
		end

		on KInteger.(i) do
			i.to_s
		end

		on KString.(s) do
			s
		end

#		on _ do |obj|
#			pp obj
#			pp obj.destructure(42)

#			:bar
#		end
	end
end
