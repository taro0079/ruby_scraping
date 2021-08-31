require 'nokogiri'
require 'open-uri'

Properties = Struct.new(
  :rentfee,
  :managementfee,
  :sikikin,
  :hosyokin,
  :gratuity_fee,
  :expense_deposits_fee,
  :madori_and_area,
  :address,
  :renewal_fee,
  keyword_init: true
)

class Scraping
  attr_reader :doc, :xpaths

  def initialize(url)
    @doc = Nokogiri::HTML(URI.open(url), nil, 'utf-8')
    @xpaths = Properties.new(
      rentfee: '/html/body/div[1]/div[2]/form[1]/div[6]/div/div/table/tbody/tr[1]/td/div[2]/span[1]/span[1]',
      managementfee: '/html/body/div[1]/div[2]/form[1]/div[6]/div/div/table/tbody/tr[1]/td/div[2]/span[1]/span[3]',
      sikikin: '/html/body/div[1]/div[2]/form[1]/div[6]/div/div/table/tbody/tr[1]/td/div[2]/span[2]/span[2]',
      hosyokin: '/html/body/div[1]/div[2]/form[1]/div[6]/div/div/table/tbody/tr[1]/td/div[2]/span[2]/span[3]',
      gratuity_fee: '/html/body/div[1]/div[2]/form[1]/div[6]/div/div/table/tbody/tr[1]/td/div[2]/span[2]/span[5]',
      expense_deposits_fee: '/html/body/div[1]/div[2]/form[1]/div[6]/div/div/table/tbody/tr[1]/td/div[2]/span[2]/span[7]',
      madori_and_area: '/html/body/div[1]/div[2]/form[1]/div[6]/div/div/table/tbody/tr[2]/td[1]',
      address: '/html/body/div[1]/div[2]/form[1]/div[6]/div/div/table/tbody/tr[4]/td',
      renewal_fee: '/html/body/div[1]/div[2]/form[1]/div[8]/div/table/tbody/tr[5]/td[1]'
    )
  end

  def allproperties
    Properties.new(
      rentfee: rentfee,
      managementfee: managementfee,
      sikikin: sikikin,
      hosyokin: hosyokin,
      gratuity_fee: gratuityfee,
      expense_deposits_fee: expensedepositefee,
      madori_and_area: madori_and_area,
      address: address,
      renewal_fee: renewal_fee
    )
  end

  private

  def scraping_data(target)
    doc.xpath(target).text
  end

  def rentfee
    # doc.xpath(xpaths[:rentfee]).text.delete(',').to_i
    scraping_data(xpaths[:rentfee])
  end

  def managementfee
    # doc.xpath(xpaths[:managementfee]).text.delete(',').delete('¥').to_i
    scraping_data(xpaths[:managementfee])
  end

  def sikikin
    # TODO: 処理がおおすぎる。どうにかして切りわけたい。
    # huyou_to_zero(doc.xpath(xpaths[:sikikin]).text)
    scraping_data(xpaths[:sikikin])
  end

  def hosyokin
    # huyou_to_zero(doc.xpath(xpaths[:hosyokin]).text)
    scraping_data(xpaths[:hosyokin])
  end

  def gratuityfee
    scraping_data(xpaths[:gratuity_fee])
  end

  def expensedepositefee
    scraping_data(xpaths[:expense_deposits_fee])
  end

  def madori_and_area
    scraping_data(xpaths[:madori_and_area])
  end

  def address
    scraping_data(xpaths[:address])
  end

  def renewal_fee
    scraping_data(xpaths[:renewal_fee])
  end
end

class TextFormatting
  attr_reader :data

  def initialize(data)
    @data = data
  end

  private

  # 不要を0に変換
  def huyou_to_zero(data)
    return 0 if data.include?('不要')
  end
end
