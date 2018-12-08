# RecipeCrawler

A **web crawler** to save recipes from [marmiton.org](http://www.marmiton.org/), [750g.com](http://www.750g.com) or [cuisineaz.com](http://www.cuisineaz.com) into an **SQlite3** database.

> For the moment, it works only with [cuisineaz.com](http://www.cuisineaz.com)

This *Rubygems* use my other **powerfull** [recipe_scraper](https://github.com/madeindjs/recipe_scraper) gem to scrape data on these websites.

To experiment with that code, run `bin/console` for an interactive prompt.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'recipe_crawler'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install recipe_crawler

## Usage

### Command line

Install this gem and run

    $ recipe_crawler -h
    Usage: recipe_crawler [options]
        -n, --number x                   Number of recipes to fetch
        -u, --url url                    URL of a recipe to fetch

So you just need to specify the first recipe url and the number of recipes wanted. Simple like this :

    $ recipe_crawler -u http://www.cuisineaz.com/recettes/pate-a-pizza-legere-55004.aspx -n 8
    [x] Pâte à pizza légère fetched!
    [x] Pâtes au jambon cuit fetched!
    [x] Oeufs au plat sucrés fetched!
    [x] Pizza légère fetched!
    [x] Vin cuit fetched!
    [x] Tiramisu aux framboises simplissime et rapide fetched!
    [x] Risotto aux champignons et au parmesan fetched!
    [x] Gnocchi fetched!


### API

Install & import the library:

    require 'recipe_scraper'

Then you just need to instanciate a `RecipeCrawler::Crawler` with url of a CuisineAZ's recipe.

    url = 'http://www.cuisineaz.com/recettes/pate-a-pizza-legere-55004.aspx'
    r = RecipeCrawler::Crawler.new url

Then you just need to run the crawl with a limit number of recipe to fetch. All recipes will be saved in a *export.sqlite3* file. You can pass a block to play with `RecipeScraper::Recipe` objects.

    r.crawl!(limit: 10) do |recipe|
        puts recipe.to_hash
        # will return
        # --------------
        # { :cooktime => 7,
        #        :image => "http://images.marmitoncdn.org/recipephotos/multiphoto/7b/7b4e95f5-37e0-4294-bebe-cde86c30817f_normal.jpg",
        #        :ingredients => ["2 beaux avocat", "2 steaks hachés de boeuf", "2 tranches de cheddar", "quelques feuilles de salade", "1/2 oignon rouge", "1 tomate", "graines de sésame", "1 filet d'huile d'olive", "1 pincée de sel", "1 pincée de poivre"],
        #        :preptime => 20,
        #        :steps => ["Laver et couper la tomate en rondelles", "Cuire les steaks à la poêle avec un filet d'huile d'olive", "Saler et poivrer", "Toaster les graines de sésames", "Ouvrir les avocats en 2, retirer le noyau et les éplucher", "Monter les burger en plaçant un demi-avocat face noyau vers le haut, déposer un steak, une tranche de cheddar sur le steak bien chaud pour qu'elle fonde, une rondelle de tomate, une rondelle d'oignon, quelques feuilles de salade et terminer par la seconde moitié d'avocat", "Parsemer quelques graines de sésames."],
        #        :title => "Burger d'avocat",
        #  }
    end


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. You can also run `yard` to generate the documentation.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/recipe_crawler. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Author

[Rousseau Alexandre](https://github.com/madeindjs)
