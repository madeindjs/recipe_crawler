require 'recipe_scraper'

module RecipeCrawler

	# This is the main class to crawl recipes from a given url
	#
	# @attr url [String] first url parsed
	class Crawler

		ALLOWED_URLS = [
			'http://www.cuisineaz.com/recettes/',
			'http://www.marmiton.org/recettes/',
			'http://www.750g.com/'
		]

		attr_reader :url


		# 
		# Check if the url can be parsed
		# @param url [type] [description]
		# 
		# @return [Boolean] true if url can be parsed	
		def self.url_valid? url
			ALLOWED_URLS.each { |url_allowed| return true if url.include? url_allowed }
			return false
		end


		# 
		# Create a Crawler
		# @param url [String] a url a recipe to scrawl other one
		def initialize url
			if Crawler::url_valid? url
				@url = url
			else
				raise ArgumentError , 'This url cannot be used'
			end
		end

		#
		# Start the crawl
		def crawl!
			# @TODO write logic here
		end

	end


end