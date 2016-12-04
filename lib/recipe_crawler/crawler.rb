require 'recipe_scraper'
require 'nokogiri'

module RecipeCrawler

	# This is the main class to crawl recipes from a given url
	#
	# @attr url [String] first url parsed
	# @attr host [Symbol] of url's host
	class Crawler

		# URL than crawler can parse
		ALLOWED_URLS = {
			cuisineaz: 'http://www.cuisineaz.com/recettes/',
			marmiton: 'http://www.marmiton.org/recettes/',
			g750: 'http://www.750g.com/'
		}

		attr_reader :url, :host


		# 
		# Check if the url can be parsed and set the host
		# 
		# @return [Boolean] true if url can be parsed	
		def url_valid?
			ALLOWED_URLS.each do |host, url_allowed| 
				if url.include? url_allowed 
					@host = host
					return true
				end
			end
			return false
		end


		# 
		# Create a Crawler
		# @param url [String] a url a recipe to scrawl other one
		def initialize url
			@url = url
			raise ArgumentError , 'This url cannot be used' unless url_valid?
		end

		#
		# Start the crawl
		def crawl!
			# @TODO write logic here
		end

	end


end