require 'nokogiri'
require 'open-uri'

class Scraping
  attr_reader :doc, :xpaths

  Properties = Struct.new(
    :rentfee,
    :managementfee,
    :sikikin,
    :hosyokin,
    :gratuity_fee,
    :expense_deposits_fee,
    :madori_and_area,
    keyword_init: true
  )

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
      address: '/html/body/div[1]/div[2]/form[1]/div[6]/div/div/table/tbody/tr[4]/td'
    )
  end

  def rentfee
    doc.xpath(xpaths[:rentfee]).text.delete(',').to_i
  end

  def managementfee
    doc.xpath(xpaths[:managementfee]).text.delete(',').delete('¥').to_i
  end

  def sikikin
    # TODO 処理がおおすぎる。どうにかして切りわけたい。
    huyou_to_zero(doc.xpath(xpaths[:sikikin]).text)
  end

  def hosyokin
    huyou_to_zero(doc.xpath(xpaths[:hosyokin]).text)
  end

  def gratuityfee
    doc.xpath(xpaths[:gratuity_fee]).text
  end

  def expensedepositefee
    doc.xpath(xpaths[:expense_deposits_fee]).text
  end

  def madori_and_area
    doc.xpath(xpaths[:madori_and_area]).text
  end

  def address
    doc.xpath(xpaths[:address]).text
  end

  private

  # 不要を0に変換
  def huyou_to_zero(data)
    return 0 if data.include?('不要')
  end
end
