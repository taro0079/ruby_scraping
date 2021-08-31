require "test/unit"
require "./scraping"

class TC_Scraping < Test::Unit::TestCase
  def setup
    @obj = Scraping.new("https://www.leopalace21.com/app/searchCondition/detail/r/0000041623105.html#pagetop")
  end

  def test_all_properties
    p @obj.allproperties
  end

  def test_text_formatting
    p TextFormatting.new(@obj.allproperties).data
  end
end
