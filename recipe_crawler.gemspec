# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'recipe_crawler/version'

Gem::Specification.new do |spec|
  spec.name          = "recipe_crawler"
  spec.version       = RecipeCrawler::VERSION
  spec.authors       = ["madeindjs"]
  spec.email         = ["madeindjs@gmail.com"]

  spec.summary       = %q{Get all recipes from famous french cooking websites}
  spec.description   = %q{This crawler will use my personnal scraper named 'RecipeScraper' to dowload recipes data from Marmiton, 750g or cuisineaz}
  spec.homepage      = "https://github.com/madeindjs/recipe_crawler."
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'http://mygemserver.com'
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "recipe_scraper", '>= 2.2.0'


  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "yard"
end
