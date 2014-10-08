# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_mailman/version'

Gem::Specification.new do |spec|
  spec.name          = "ruby_mailman"
  spec.version       = RubyMailman::VERSION
  spec.authors       = ["Ian Whitney"]
  spec.email         = ["whit0694@umn.edu"]
  spec.summary       = %q{A ruby library for connecting to Central Service}
  spec.description   = %q{Ruby implementation of the Central Service interface. Meant for use with UMN API Services written in Ruby.}
  spec.homepage      = "https://github.com/umnapi/ruby_mailman"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.3"
  spec.add_development_dependency "protobuf", "~> 3.3"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_runtime_dependency "ffi-rzmq", "~> 2.0"
end
