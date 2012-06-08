# -*- encoding: utf-8 -*-
require File.expand_path('../lib/nano_store/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Francis Chong"]
  gem.email         = ["francis@ignition.hk"]
  gem.description   = "Wrapper for NanoStore, a lightweight schema-less key-value document database based on sqlite, for RubyMotion."
  gem.summary       = "Wrapper for NanoStore, a lightweight schema-less key-value document database based on sqlite, for RubyMotion."
  gem.homepage      = "https://github.com/siuying/NanoStoreInMotion"

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "nano-store"
  gem.require_paths = ["lib"]
  gem.version       = NanoStore::VERSION

  gem.add_dependency 'bubble-wrap', '0.3.1'
  gem.add_dependency 'motion-cocoapods', '>= 1.0.1'
  gem.add_development_dependency 'motion-redgreen'
end
