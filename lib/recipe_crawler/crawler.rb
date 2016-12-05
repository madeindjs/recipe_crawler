require 'recipe_scraper'
require 'nokogiri'
require 'open-uri'
require 'sqlite3'


module RecipeCrawler

	# This is the main class to crawl recipes from a given url
	#   1. Crawler will crawl url to find others recipes urls on the website
	#   2. it will crawl urls founded to find other url again & again
	#   3. it will scrape urls founded to get data
	#
	# @attr url [String] first url parsed
	# @attr host [Symbol] of url's host
	# @attr scraped_urls [Array<String>] of url's host
	# @attr crawled_urls [Array<String>] of url's host
	# @attr to_crawl_urls [Array<String>] of url's host
	# @attr recipes [Array<RecipeSraper::Recipe>] recipes fetched
	#
	# @attr db [SQLite3::Database] Sqlite database where recipe will be saved
	class Crawler

		# URL than crawler can parse
		ALLOWED_URLS = {
			cuisineaz: 'http://www.cuisineaz.com/recettes/',
			marmiton: 'http://www.marmiton.org/recettes/',
			g750: 'http://www.750g.com/'
		}

		attr_reader :url, :host, :scraped_urls, :crawled_urls, :to_crawl_urls, :recipes


		# 
		# Create a Crawler
		# @param url [String] a url a recipe to scrawl other one
		def initialize url
			@url = url
			if url_valid?
				@recipes = []
				@crawled_urls = []
				@scraped_urls = []
				@to_crawl_urls = []
				@to_crawl_urls << url
				@db = SQLite3::Database.new "results.sqlite3"
				@db.execute "CREATE TABLE IF NOT EXISTS recipes(
					Id INTEGER PRIMARY KEY, 
					title TEXT, 
					preptime INTEGER, 
					cooktime INTEGER, 
					ingredients TEXT, 
					steps TEXT, 
					image TEXT
				)"
			else
				raise ArgumentError , 'This url cannot be used'
			end
		end


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
		# Start the crawl
		# @param limit [Integer]
		#
		# @yield [RecipeSraper::Recipe] as recipe scraped
		def crawl! limit=2
			# find all link on url given (and urls of theses)
			if @host == :cuisineaz
				while !@to_crawl_urls.empty?
					get_links to_crawl_urls[0]
					break if @crawled_urls.count > limit
				end

			else
				raise NotImplementedError
			end

			# scrap urls
			recipes_returned = 0
			@crawled_urls.each{ |crawled_url|
				if limit > recipes_returned
					yield scrape crawled_url
					recipes_returned += 1
				else
					break
				end
			} if block_given?
		end


		#
		# Scrape given url
		# param url [String] as url to scrape
		#
		# @return [RecipeSraper::Recipe] as recipe scraped
		def scrape url
			recipe = RecipeSraper::Recipe.new url
			@scraped_urls << url
			@recipes << recipe
			if save recipe
				return recipe
			else
				raise SQLite3::Exception, 'accnot save recipe'
			end
		end


		#
		# Get recipes links from the given url
		# @param url [String] as url to scrape
		#
		# @return [void]
		def get_links url
			# catch 404 error from host
			begin
				doc = Nokogiri::HTML(open(url))
				# find internal links on page
				doc.css('#tagCloud  a').each do |link|
					link = link.attr('href')
					# If link correspond to a recipe we add it to recipe to scraw
					if link.include?(ALLOWED_URLS[@host]) and !@crawled_urls.include?(url)
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


		#
		# Save recipe
		# @param recipe [RecipeSraper::Recipe] as recipe to save
		#
		# @return [Boolean] as true if success
		def save recipe
			begin
				@db.execute "INSERT INTO recipes (title, preptime, cooktime, ingredients, steps, image)
						VALUES (:title, :preptime, :cooktime, :ingredients, :steps, :image)",
						title: recipe.title,
						preptime: recipe.preptime,
						ingredients: recipe.ingredients.join("\n"),
						steps: recipe.steps.join("\n"),
						image: recipe.image

				return true
				
			rescue SQLite3::Exception => e 
					puts "Exception occurred #{e}"
					return false
			end
		end
	end


end