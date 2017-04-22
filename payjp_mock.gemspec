# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'payjp_mock/version'

Gem::Specification.new do |spec|
  spec.name          = "payjp_mock"
  spec.version       = PayjpMock::VERSION
  spec.authors       = ["kirikiriyamama"]
  spec.email         = ["kirikiriyamama@gmail.com"]

  spec.summary       = "A stubbing library for PAY.JP"
  spec.description   = "This library creates PAY.JP API stubs and generates dummy responses"
  spec.homepage      = "https://github.com/kirikiriyamama/payjp_mock"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'addressable'
  spec.add_dependency 'webmock'

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "payjp"
end
