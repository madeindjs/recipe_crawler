lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'recipe_crawler/version'

Gem::Specification.new do |spec|
  spec.name          = 'recipe_crawler'
  spec.version       = RecipeCrawler::VERSION
  spec.authors       = ['Alexandre Rousseau']
  spec.email         = ['contact@rousseau-alexandre.fr']

  spec.summary       = 'Get all recipes from famous french cooking websites'
  spec.description   = "This crawler will use my personnal scraper named 'RecipeScraper' to dowload recipes data from Marmiton, 750g or cuisineaz"
  spec.homepage      = 'https://github.com/madeindjs/recipe_crawler'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = ['recipe_crawler']
  spec.require_paths = ['lib']

  spec.add_dependency 'recipe_scraper', '~> 2.0'
  spec.add_dependency 'sqlite3', '~> 1.3'

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'yard'
end
