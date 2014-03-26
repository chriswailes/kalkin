# Author:		Chris Wailes <chris.wailes@gmail.com>
# Project: 	Kalkin
# Date:		2014/03/25
# Description:	This is the Gem specification for Kalkin.

require File.expand_path("../lib/rltk/version", __FILE__)

Gem::Specification.new do |s|
	s.platform = Gem::Platform::RUBY
	
	s.name        = 'kalkin'
	s.version     = Kalkin::VERSION
	s.summary     = 'Elegent complexity'
	s.description = "A toy language"
	
	s.files = [
		'LICENSE',
		'AUTHORS',
		'README.md',
		'Rakefile',
	] +
	Dir.glob('lib/**/*.rb')
			
	s.test_files = Dir['test/**/**.rb']
	
	s.require_path	= 'lib'
	
	s.author   = 'Chris Wailes'
	s.email    = 'chris.wailes+kalkin@gmail.com'
	s.homepage = 'https://github.com/chriswailes/Kalkin'
	s.license  = 'University of Illinois/NCSA Open Source License'
	
	s.required_ruby_version = '>= 2.0.0'
	
	################
	# Dependencies #
	################
	
	s.add_dependency('rltk', '>= 3.0.0')
	s.add_dependency('filigree', '>= 0.2.1')
	
	############################
	# Development Dependencies #
	############################
	
	s.add_development_dependency('bundler')
	s.add_development_dependency('flay')
	s.add_development_dependency('flog')
	s.add_development_dependency('minitest')
	s.add_development_dependency('pry')
	s.add_development_dependency('rake')
	s.add_development_dependency('rake-notes')
	s.add_development_dependency('reek')
	s.add_development_dependency('rubygems-tasks')
	s.add_development_dependency('simplecov')
	s.add_development_dependency('yard', '>= 0.8.1')
end
