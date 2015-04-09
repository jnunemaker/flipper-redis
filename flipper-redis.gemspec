# -*- encoding: utf-8 -*-
require File.expand_path('../lib/flipper/adapters/redis/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "flipper-redis"
  gem.version       = Flipper::Adapters::Redis::VERSION
  gem.authors       = ["John Nunemaker"]
  gem.email         = ["nunemaker@gmail.com"]
  gem.description   = %q{Redis adapter for Flipper}
  gem.summary       = %q{Redis adapter for Flipper}
  gem.homepage      = "http://jnunemaker.github.com/flipper-redis"
  gem.require_paths = ["lib"]

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})

  gem.add_dependency 'flipper', '~> 0.7.0.beta1'
  gem.add_dependency 'redis', '>= 2.2', '< 4.0.0'
end
