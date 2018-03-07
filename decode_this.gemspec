# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'decode_this/version'

Gem::Specification.new do |spec|
  spec.name                          = 'decode_this'
  spec.version                       = DecodeThis::VERSION
  spec.summary                       = 'Decode token. This token'
  spec.description                   = 'Simple gem for decoding JWT token'
  spec.authors                       = ['Sasha Kotov']
  spec.email                         = 'amikotov@bookmate.com'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
end
