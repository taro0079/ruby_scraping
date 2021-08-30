require 'nokogiri'
require 'open-uri'

class Scraping
  attr_reader :doc
  def initialize(url)
    @doc = Nokogiri::HTML(URI.open(url), nil, 'utf-8')
  end
end

class ProperPage
end
t = Scraping.new('https://www.leopalace21.com/m/sp/r/detail/0000024110103/#pagetop')
puts t.doc
