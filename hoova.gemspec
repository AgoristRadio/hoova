# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hoova/version'

Gem::Specification.new do |gem|
  gem.name          = "hoova"
  gem.version       = Hoova::VERSION
  gem.authors       = ["Hiro White"]
  gem.email         = ["hiro@agoristradio.com"]
  gem.description   = %q{The Bitcoin Wallet Sweeper.}
  gem.summary       = %q{Sweeps balances.}
  gem.homepage      = "http://agoristradio.github.com/hoova/"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'factory_girl'
  gem.add_development_dependency 'rb-inotify'
  gem.add_development_dependency 'cucumber'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'guard'
  gem.add_development_dependency 'guard-cucumber'
  gem.add_development_dependency 'guard-rspec'

  gem.add_dependency 'rest-client'
  gem.add_dependency 'awesome_print'
  gem.add_dependency 'pry'

end
