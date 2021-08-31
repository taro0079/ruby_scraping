require 'test/unit'
require './scraping'

class TC_Scraping < Test::Unit::TestCase
  def setup
    @obj = Scraping.new('https://www.leopalace21.com/app/searchCondition/detail/r/0000041623105.html#pagetop')
  end

  def test_scraping_alldata
    p @obj.allproperties
  end

  def test_formatting_alldata
    p TextFormatting.new(@obj.allproperties).allproperties
  end

end
