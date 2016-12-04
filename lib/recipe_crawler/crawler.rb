require 'recipe_scraper'

module RecipeCrawler

	# This is the main class to crawl recipes from a given url
	class Crawler

		ALLOWED_URLS = [
			'http://www.cuisineaz.com/recettes/',
			'http://www.marmiton.org/recettes/',
			'http://www.750g.com/'
		]

		attr_reader :url

		def initialize url
			if ALLOWED_URLS.include? url
				@url = url
			else
				raise ArgumentError , 'This url cannot be used'
			end
		end

		
	end


end