# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hasten/version'

Gem::Specification.new do |spec|
  spec.name          = "hasten"
  spec.version       = Hasten::VERSION
  spec.authors       = ["Derrick Parkhurst"]
  spec.email         = ["derrick.parkhurst@gmail.com"]
  spec.summary       = "Hasten the import of mysqldump exports into mysql"
  spec.description   = "Hasten the import of mysql dumps, especially those containing very large innodb tables with multiple indexes."
  spec.homepage      = "http://github.com/thirtysixthspan/hasten"
  spec.license       = "MIT"

  spec.files         = Dir['Rakefile', '{bin,lib,spec}/**/*', 'README*', 'LICENSE*']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
