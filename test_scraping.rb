require "test/unit"
require "./scraping"

class TC_Scraping < Test::Unit::TestCase
  def setup
    @obj = Scraping.new("https://www.leopalace21.com/app/searchCondition/detail/r/0000041623105.html#pagetop")
  end

  def test_rentfee
    item = TextFormatting.new(@obj.allproperties).rent_fee
    assert_equal(40000, item)
  end
  def test_managementfee
    item = TextFormatting.new(@obj.allproperties).management_fee
    assert_equal(6500, item)
  end
end
