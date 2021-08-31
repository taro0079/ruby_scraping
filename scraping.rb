require 'nokogiri'
require 'open-uri'

class Scraping
  attr_reader :doc, :xpaths

  Properties = Struct.new(
    :rentfee,
    :managementfee,
    :sikikin,
    :hosyokin,
    keyword_init: true
  )

  def initialize(url)
    @doc = Nokogiri::HTML(URI.open(url), nil, 'utf-8')
    @xpaths = Properties.new(
      rentfee: '/html/body/div[1]/div[2]/form[1]/div[6]/div/div/table/tbody/tr[1]/td/div[2]/span[1]/span[1]',
      managementfee: '/html/body/div[1]/div[2]/form[1]/div[6]/div/div/table/tbody/tr[1]/td/div[2]/span[1]/span[3]',
      sikikin: '/html/body/div[1]/div[2]/form[1]/div[6]/div/div/table/tbody/tr[1]/td/div[2]/span[2]/span[2]',
      hosyokin: '/html/body/div[1]/div[2]/form[1]/div[6]/div/div/table/tbody/tr[1]/td/div[2]/span[2]/span[3]'
    )
  end

  def rentfee
    doc.xpath(xpaths[:rentfee]).text.delete(',').to_i
  end

  def managementfee
    doc.xpath(xpaths[:managementfee]).text.delete(',').delete('¥').to_i
  end

  def sikikin
    huyou_to_zero(doc.xpath(xpaths[:sikikin]).text)
  end

  def hosyokin
    huyou_to_zero(doc.xpath(xpaths[:hosyokin]).text)
  end

  private

  # 不要を0に変換
  def huyou_to_zero(data)
    return 0 if data.include?('不要')
  end
end
