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
	# @attr_reader url [String] first url parsed
	# @attr_reader host [Symbol] of url's host
	# @attr_reader scraped_urls [Array<String>] of url's host
	# @attr_reader crawled_urls [Array<String>] of url's host
	# @attr_reader to_crawl_urls [Array<String>] of url's host
	# @attr_reader recipes [Array<RecipeSraper::Recipe>] recipes fetched
	# @attr_reader db [SQLite3::Database] Sqlite database where recipe will be saved
	class Crawler

		# URL than crawler can parse
		ALLOWED_URLS = {
			cuisineaz: 'http://www.cuisineaz.com/recettes/',
			marmiton: 'http://www.marmiton.org/recettes/',
			g750: 'http://www.750g.com/'
		}

		attr_reader :url, :host, :scraped_urls, :crawled_urls, :to_crawl_urls, :recipes
		attr_accessor :interval_sleep_time

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
				@interval_sleep_time = 0
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
		# @param limit [Integer] the maximum number of scraped recipes
		# @param interval_sleep_time [Integer] waiting time between scraping
		#
		# @yield [RecipeSraper::Recipe] as recipe scraped
		def crawl! limit=2, interval_sleep_time=0
			recipes_returned = 0
			
			if @host == :cuisineaz

				while !@to_crawl_urls.empty? and limit > @recipes.count
					# find all link on url given (and urls of theses)
					get_links @to_crawl_urls[0]
					# now scrape an url
					recipe = scrape @to_crawl_urls[0]
					yield recipe if recipe and block_given?
					sleep interval_sleep_time
				end

			else
				raise NotImplementedError
			end
		end


		#
		# Scrape given url
		# param url [String] as url to scrape
		#
		# @return [RecipeSraper::Recipe] as recipe scraped
		# @return [nil] if recipe connat be fetched
		def scrape url
			begin
				recipe = RecipeSraper::Recipe.new url
				@scraped_urls << url
				@recipes << recipe
				if save recipe
					return recipe
				else
					raise SQLite3::Exception, 'cannot save recipe'
				end
			rescue OpenURI::HTTPError
				return nil
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