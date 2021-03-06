# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'salish/version'

Gem::Specification.new do |spec|
  spec.name          = "salish"
  spec.version       = Salish::VERSION
  spec.authors       = ["shitake"]
  spec.email         = ["z1522716486@hotmail.com"]
  spec.description   = %q{Ruby command-line tool kit}
  spec.summary       = %q{A Ruby command-line tool kit. Support for multiple subcommands created.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end

