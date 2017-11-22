# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fog/ovirt/version'

Gem::Specification.new do |spec|
  spec.name          = 'fog-ovirt'
  spec.version       = Fog::Ovirt::VERSION
  spec.authors       = ['Ori Rabin']
  spec.email         = ['orabin@redhat.com']

  spec.summary       = "Module for the 'fog' gem to support Ovirt."
  spec.description   = 'This library can be used as a module for `fog`.'
  spec.homepage      = 'https://github.com/fog/fog-ovirt'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^tests\/})

  spec.require_paths = ['lib']

  spec.add_dependency("fog-core", "~> 1.45")
  spec.add_dependency("fog-json")
  spec.add_dependency("fog-xml", "~> 0.1.1")
  #spec.add_dependency("rbovirt", "~> 0.1.4")

  spec.add_dependency "ovirt-engine-sdk", ">= 4.1.3"

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop', '~> 0.34'
  spec.add_development_dependency 'shindo', '~> 0.3'
end
