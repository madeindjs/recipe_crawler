require 'spec_helper'

describe RecipeCrawler do

  it 'has a version number' do
    expect(RecipeCrawler::VERSION).not_to be nil
  end

  it 'should instanciate a recipe' do
    expect(RecipeCrawler::Crawler.new 'http://www.cuisineaz.com/recettes/').not_to be nil
    expect(RecipeCrawler::Crawler.new 'http://www.cuisineaz.com/recettes/pate-a-pizza-legere-55004.aspx').not_to be nil
  end

  it 'should not instanciate with this bad url'  do
    expect{RecipeCrawler::Crawler.new 'http://www.google.com'}.to raise_error ArgumentError
  end

  it "should found host" do
    expect(RecipeCrawler::Crawler.new('http://www.cuisineaz.com/recettes/pate-a-pizza-legere-55004.aspx').host).to equal :cuisineaz
    expect(RecipeCrawler::Crawler.new('http://www.marmiton.org/recettes/recette_baba-au-rhum-express_13608.aspx').host).to equal :marmiton
    expect(RecipeCrawler::Crawler.new('http://www.750g.com/sapin-de-noel-on-le-mange-r200307.htm').host).to equal :g750
  end

  it "should found links on page" do
    r = RecipeCrawler::Crawler.new 'http://www.cuisineaz.com/recettes/pate-a-pizza-legere-55004.aspx'
    r.crawl!(1)
    expect(r.crawled_urls).not_to be []
  end

  it "should yield RecipeScraper" do
    r = RecipeCrawler::Crawler.new 'http://www.cuisineaz.com/recettes/pate-a-pizza-legere-55004.aspx'
    r.crawl!(1) do |recipe|
      expect(recipe).to be_kind_of(RecipeSraper::Recipe)
    end
  end


  it "should yield not more limit" do
    r = RecipeCrawler::Crawler.new 'http://www.cuisineaz.com/recettes/concombre-a-la-creme-fraiche-et-a-la-ciboulette-56227.aspx'
    limit = 8
    expect { |block| r.crawl! limit, &block }.to yield_control.exactly(limit).times
    expect(r.recipes.count).to equal limit
  end


  it "should create a result.sqlite3 file" do
    r = RecipeCrawler::Crawler.new 'http://www.cuisineaz.com/recettes/pate-a-pizza-legere-55004.aspx'
    expect File.exists?('result.sqlite3')
  end


end
