# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'featurator/version'

Gem::Specification.new do |spec|
  spec.name          = 'featurator'
  spec.version       = Featurator::VERSION
  spec.authors       = ['Jason Roth']
  spec.email         = ['jroth@tendrilinc.com']
  spec.summary       = %q{A feature flag framework.}
  spec.description   = %q{Feature flags are hard. Not sure this makes it any easier.}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split('\x0')
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest', '~> 5.0'
end
