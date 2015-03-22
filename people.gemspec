# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'people/version'

Gem::Specification.new do |s|
  s.name = "people"
  s.version = People::VERSION

  s.authors = ["Matthew Ericson"]
  s.email = ["mericson@ericson.net"]

  s.date = "2013-03-07"

  s.require_paths = ["lib"]
  s.rubygems_version = "~> 1.8"
  s.required_ruby_version = '>= 2.1'
  s.summary = "Matts Name Parser"
  s.description = ""
  s.homepage = "http://github.com/mericson/people"
  s.license       = "MIT"

  s.files         = s.files.grep(%r{^lib/}) #{}`git ls-files -z`.split("\x0")
  #s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})

  s.add_development_dependency "bundler", "~> 1.5"
  s.add_development_dependency "rspec", "~> 3.2"
  s.add_development_dependency "rake"

end

