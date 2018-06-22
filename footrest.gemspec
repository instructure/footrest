# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'footrest/version'

Gem::Specification.new do |gem|
  gem.authors =       ["Duane Johnson", "Nathan Mills"]
  gem.email =         ["duane@instructure.com", "nathanm@instructure.com"]
  gem.description =   %q{Ruby interface for restful APIs}
  gem.summary =       %q{REST APIs}
  gem.homepage =      'https://github.com/instructure/footrest'
  gem.license =       'MIT'

  gem.files = %w[Rakefile footrest.gemspec]
  gem.files += Dir.glob("lib/**/*.rb")
  gem.files += Dir.glob("spec/**/*")
  gem.test_files    = Dir.glob("spec/**/*")
  gem.name          = "footrest"
  gem.require_paths = ["lib"]
  gem.version       = Footrest::VERSION

  gem.add_development_dependency "rake"
  gem.add_development_dependency "bundler"
  gem.add_development_dependency "rspec", "~> 3.3"
  gem.add_development_dependency "webmock"
  gem.add_development_dependency "pry"
  gem.add_development_dependency "byebug"

  gem.add_dependency "faraday", ">= 0.9.0", "< 1"
  gem.add_dependency "activesupport", ">= 3.0.0"

  # Parses Link headers formatted according to RFC 5988 draft spec
  gem.add_dependency "link_header", ">= 0.0.7"
end
