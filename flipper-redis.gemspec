# -*- encoding: utf-8 -*-
require File.expand_path('../lib/flipper/adapters/redis/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["John Nunemaker"]
  gem.email         = ["nunemaker@gmail.com"]
  gem.description   = %q{Redis adapter for Flipper}
  gem.summary       = %q{Redis adapter for Flipper}
  gem.homepage      = "http://jnunemaker.github.com/flipper-redis"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})

  gem.name          = "flipper-redis"
  gem.require_paths = ["lib"]
  gem.version       = Flipper::Adapters::Redis::VERSION
  gem.add_dependency 'flipper', '~> 0.4'
  gem.add_dependency 'redis'
end
