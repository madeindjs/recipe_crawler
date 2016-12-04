require 'recipe_scraper'
require 'nokogiri'
require 'open-uri'


module RecipeCrawler

	# This is the main class to crawl recipes from a given url
	#
	# @attr url [String] first url parsed
	# @attr host [Symbol] of url's host
	# @attr crawled_url [Array] of url's host
	# @attr to_crawl_url [Array] of url's host
	class Crawler

		# URL than crawler can parse
		ALLOWED_URLS = {
			cuisineaz: 'http://www.cuisineaz.com/recettes/',
			marmiton: 'http://www.marmiton.org/recettes/',
			g750: 'http://www.750g.com/'
		}

		attr_reader :url, :host, :crawled_url, :to_crawl_url


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
			if url_valid?
				@crawled_url = []
				@to_crawl_url = []
				@to_crawl_url << url
			else
				raise ArgumentError , 'This url cannot be used'
			end
		end

		#
		# Start the crawl
		def crawl!
			if @host == :cuisineaz
				doc = Nokogiri::HTML(open("http://www.threescompany.com/"))
				doc.css('#tagCloud ul li a').each do |link|
					@to_crawl_url << link.attr('href')
					puts @to_crawl_url
				end
			else
				raise NotImplementedError
			end
		end

	end


end