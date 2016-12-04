require 'spec_helper'

describe RecipeCrawler do

  it 'has a version number' do
    expect(RecipeCrawler::VERSION).not_to be nil
  end

  it 'should instanciate a recipe' do
    expect(RecipeCrawler::Crawler).not_to be nil
  end

end
