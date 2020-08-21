lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yifysubs/version'

Gem::Specification.new do |gem|
  gem.name          = "yifysubs"
  gem.version       = Yifysubs::VERSION
  gem.authors       = ["JUlien Ramel"]
  gem.email         = ["julien.ramel@gmail.com"]
  gem.description   = %q{Ruby API Client for Yifysubs.com}
  gem.summary       = %q{Yifysubs.com API Client}
  gem.homepage      = "https://github.com/jujudellago/yifysubs"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "faraday",  ">= 0.9.0"
  gem.add_dependency "nokogiri", ">= 1.6.0"
  gem.add_development_dependency "rspec",   "~> 2.13.0"
  gem.add_development_dependency "webmock", "~> 1.10.0"
end
