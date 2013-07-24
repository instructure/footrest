# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'footrest/version'

Gem::Specification.new do |gem|
  gem.authors =       ["Nathan Mills"]
  gem.email =         ["nathanm@instructure.com"]
  gem.description =   %q{Ruby interface for restful APIs}
  gem.summary =       %q{REST APIs}

  gem.files = %w[Rakefile footrest.gemspec]
  gem.files += Dir.glob("lib/**/*.rb")
  gem.files += Dir.glob("spec/**/*")
  gem.test_files    = Dir.glob("spec/**/*")
  gem.name          = "footrest"
  gem.require_paths = ["lib"]
  gem.version       = Footrest::VERSION

  gem.add_development_dependency "bundler", ">= 1.0.0"
  gem.add_development_dependency "rspec", "~> 2.6"
  gem.add_development_dependency "webmock"
  gem.add_development_dependency "debugger"
  gem.add_development_dependency "pry"

  gem.add_dependency "faraday", "~> 0.8.7"
  gem.add_dependency "faraday_middleware", "~> 0.9.0"
end