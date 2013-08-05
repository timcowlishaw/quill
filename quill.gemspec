# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'quill/version'

Gem::Specification.new do |spec|
  spec.name          = "quill"
  spec.version       = Quill::VERSION
  spec.authors       = ["Tim Cowlishaw"]
  spec.email         = ["tim@timcowlishaw.co.uk"]
  spec.description   = %q{Quill helps you organize your code more easily by separating the business of specifying a class's dependencies from the business of actually providing them, using a simple, declerative syntax.}
  spec.summary       = %q{Quill - Simple DI for your rupy applications}
  spec.homepage      = "http://github.com/timcowlishaw/quill"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "cucumber"
end
