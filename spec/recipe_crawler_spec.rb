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

  it "should start to crawl" do
  end

end
