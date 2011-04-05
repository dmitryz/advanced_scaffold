# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "advanced_scaffold/version"

Gem::Specification.new do |s|
  s.name        = "advanced_scaffold"
  s.version     = AdvancedScaffold::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Dmitry Biryukov"]
  s.email       = ["dmitry@biryukov.net"]
  s.homepage    = "https://github.com/dmitryz/advanced_scaffold"
  s.summary     = %q{Advanced scaffolding with pagination and ajax}
  s.description = %q{Advanced scaffolding with pagination, ajax, search, namespaces}

  s.rubyforge_project = "advanced_scaffold"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
