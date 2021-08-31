require "test/unit"
require "./scraping"

class TC_Scraping < Test::Unit::TestCase
  def setup
    @obj = Scraping.new("https://www.leopalace21.com/app/searchCondition/detail/r/0000041623105.html#pagetop")
  end

  def test_get_rentfee
    assert_equal(40000, @obj.rentfee)
  end

  def test_get_managementfee
    assert_equal(6500, @obj.managementfee)
  end
  
  def test_sikikin
    assert_equal(0, @obj.sikikin)
  end

  def test_hosyokin
    assert_equal(0, @obj.hosyokin)
  end

  def test_gratuityfee
    p @obj.gratuityfee
  end

  def test_expensedeposite
    p @obj.expensedepositefee
  end

  def test_address
    p @obj.address
  end
end
