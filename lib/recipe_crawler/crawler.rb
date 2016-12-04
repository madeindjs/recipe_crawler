require 'recipe_scraper'
require 'nokogiri'
require 'open-uri'


module RecipeCrawler

	# This is the main class to crawl recipes from a given url
	#   1. Crawler will crawl url to find others recipes urls on the website
	#   2. it will crawl urls founded to find other url again & again
	#   3. it will scrape urls founded to get data
	#
	# @attr url [String] first url parsed
	# @attr host [Symbol] of url's host
	# @attr scraped_urls [Array] of url's host
	# @attr crawled_urls [Array] of url's host
	# @attr to_crawl_urls [Array] of url's host
	class Crawler

		# URL than crawler can parse
		ALLOWED_URLS = {
			cuisineaz: 'http://www.cuisineaz.com/recettes/',
			marmiton: 'http://www.marmiton.org/recettes/',
			g750: 'http://www.750g.com/'
		}

		attr_reader :url, :host, :crawled_urls, :crawled_urls, :to_crawl_urls


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
				@crawled_urls = []
				@to_crawl_urls = []
				@to_crawl_urls << url
			else
				raise ArgumentError , 'This url cannot be used'
			end
		end


		#
		# Start the crawl
		# @param limit=10
		def crawl! limit=2
			# find all link on url given (and urls of theses)
			if @host == :cuisineaz
				while !@to_crawl_urls.empty?
					$stdout.puts scrape to_crawl_urls[0]
					break  if @crawled_urls.count > limit
				end

			else
				raise NotImplementedError
			end

			# scrap urls 
			@crawled_urls.each{|crawled_url|
				yield RecipeSraper::Recipe.new crawled_url
			}

		end


		#
		# Scrape the specified url
		# @param url [String] as url to craw
		def scrape url
			# catch 404 error from host
			begin
				doc = Nokogiri::HTML(open(url))
				# find internal links on page
				doc.css('#tagCloud  a').each do |link|
					link = link.attr('href')
					# If link correspond to a recipe we add it to recipe to scraw
					if link.include?(ALLOWED_URLS[@host]) and !@crawled_urls.include?(url)
						$stderr.puts link
						@to_crawl_urls << link
					end
				end
				@to_crawl_urls.delete url
				@crawled_urls << url
				@to_crawl_urls.uniq!

			rescue OpenURI::HTTPError
				@to_crawl_urls.delete url
				warn "#{url} cannot be reached"
			end
			
		end

	end


end