# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'factory_girl_profiling/version'

Gem::Specification.new do |spec|
  spec.name          = "factory_girl_profiling"
  spec.version       = FactoryGirlProfiling::VERSION
  spec.authors       = ["Andrey Rozhkovsky"]
  spec.email         = ["andrey.rozhkovsky@gmail.com"]
  spec.description   = %q{Prints number of times when factory was build or create and time (avg, min, max) that it took after test suite}
  spec.summary       = %q{Prints some statistic for FactoryGirl usage after test suite}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
