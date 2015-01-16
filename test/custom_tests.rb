#!/usr/bin/ruby

$: << File.join(File.dirname(File.expand_path(__FILE__)), '../lib')

require 'pp'

require 'kalkin/ast'
require 'kalkin/ast_writer'
require 'kalkin/backends/llvm'

tlns = Kalkin::AST::Namespace.new('top_level')
Kalkin::Backends::LLVM.populate_namespace(tlns)

puts Kalkin::ASTWriter.new.visit(tlns)
