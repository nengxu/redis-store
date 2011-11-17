# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "redis/i18n/version"

Gem::Specification.new do |s|
  s.name        = "redis-i18n"
  s.version     = Redis::I18n::VERSION
  s.authors     = ["Luca Guidi"]
  s.email       = ["guidi.luca@gmail.com"]
  s.homepage    = "http://jodosha.github.com/redis-store"
  s.summary     = %q{Redis store for i18n}
  s.description = %q{Redis backed store for i18n}

  s.rubyforge_project = "redis-i18n"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'rake',      '~> 0.9.2.2'
  s.add_development_dependency 'bundler',   '~> 1.1.rc'
  s.add_development_dependency 'mocha',     '~> 0.10.0'
  s.add_development_dependency 'minitest',  '~> 2.8.0'
  s.add_development_dependency 'purdytest', '~> 1.0.0'

  s.add_runtime_dependency 'redis-store',   '~> 1.1.0'
  s.add_runtime_dependency 'i18n',          '~> 0.6.0'
end
