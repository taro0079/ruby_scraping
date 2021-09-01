require 'nokogiri'
require 'open-uri'

# スクレイピングで取るデータの構造体。Hashのほうがいいか迷ってる
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
  :note,
  :movable_timing,
  :updated_at,
  :new_arrived_at,
  keyword_init: true
)

class Scraping
  attr_reader :doc, :xpaths

  def initialize(url)
    @doc = Nokogiri::HTML(URI.open(url), nil, 'utf-8')
    @xpaths = Properties.new(
      rentfee: '/html/body/div[1]/div[2]/form[1]/div[6]/div/div/table/tbody/tr[1]/td/div[2]/span[1]/span[1]',
      managementfee: '/html/body/div[1]/div[2]/form[1]/div[6]/div/div/table/tbody/tr[1]/td/div[2]/span[1]/span[3]', sikikin: '/html/body/div[1]/div[2]/form[1]/div[6]/div/div/table/tbody/tr[1]/td/div[2]/span[2]/span[2]',
      hosyokin: '/html/body/div[1]/div[2]/form[1]/div[6]/div/div/table/tbody/tr[1]/td/div[2]/span[2]/span[3]',
      gratuity_fee: '/html/body/div[1]/div[2]/form[1]/div[6]/div/div/table/tbody/tr[1]/td/div[2]/span[2]/span[5]',
      expense_deposits_fee: '/html/body/div[1]/div[2]/form[1]/div[6]/div/div/table/tbody/tr[1]/td/div[2]/span[2]/span[7]',
      madori_and_area: '/html/body/div[1]/div[2]/form[1]/div[6]/div/div/table/tbody/tr[2]/td[1]',
      address: '/html/body/div[1]/div[2]/form[1]/div[6]/div/div/table/tbody/tr[4]/td',
      renewal_fee: '/html/body/div[1]/div[2]/form[1]/div[8]/div/table/tbody/tr[5]/td[1]',
      note: '//*[@id="inquiry-form"]/div[8]/div/table/tbody/tr[6]/td/ul/li',
      movable_timing: '/html/body/div[1]/div[2]/form[1]/div[8]/div/table/tbody/tr[3]/td[1]',
      updated_at: '/html/body/div[1]/div[2]/form[1]/div[6]/p/span[1]',
      new_arrived_at: '/html/body/div[1]/div[2]/form[1]/div[6]/p/span[2]'
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
      renewal_fee: renewal_fee,
      note: note,
      movable_timing: movable_timing,
      updated_at: created_at,
      new_arrived_at: new_arrived_at
    )
  end

  # def mappingalldata
  #   xpaths.map { |xpath| scraping_data(xpath) }
  # end

  private

  def scraping_data(target)
    doc.xpath(target).text
  end

  def rentfee
    scraping_data(xpaths[:rentfee])
  end

  def managementfee
    scraping_data(xpaths[:managementfee])
  end

  def sikikin
    scraping_data(xpaths[:sikikin])
  end

  def hosyokin
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

  def note
    doc.xpath(xpaths[:note]).map { |item| item.text }
  end

  def movable_timing
    scraping_data(xpaths[:movable_timing])
  end

  public

  def updated_at
    scraping_data(xpaths[:created_at])
  end

  def new_arrived_at
    scraping_data(xpaths[:new_arrived_at])
  end
end

class TextFormatting
  attr_reader :data

  def allproperties
    Properties.new(
      rentfee: rent_fee,
      managementfee: management_fee,
      sikikin: sikikin,
      hosyokin: hosyokin
      # gratuity_fee: gratuityfee
      # expense_deposits_fee: expensedepositefee,
      # madori_and_area: madori_and_area,
      # address: address,
      # renewal_fee: renewal_fee
    )
  end

  private

  def initialize(data)
    @data = data
  end

  def rent_fee
    data[:rentfee].delete(',').to_i
  end

  def management_fee
    data[:managementfee].delete(',').delete('¥').to_i
  end

  def sikikin
    huyou_to_zero(data[:sikikin])
  end

  def hosyokin
    huyou_to_zero(data[:hosyokin])
  end

  # 不要を0に変換
  def huyou_to_zero(target)
    return 0 if target.include?('不要')
  end
end
