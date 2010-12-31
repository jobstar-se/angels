# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "angels/version"

Gem::Specification.new do |s|
  s.name        = "angels"
  s.version     = Angels::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Peder Linder"]
  s.email       = ["pederbl@jobstar.se"]
  s.homepage    = ""
  s.summary     = %q{Wrapper for daemons gem}
  s.description = %q{Wrapper for daemons gem}

  s.rubyforge_project = "angels"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('daemons')
end
