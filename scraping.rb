require "nokogiri"
require "open-uri"

class Scraping
  attr_reader :doc

  def initialize(url)
    @doc = Nokogiri::HTML(URI.open(url), nil, "utf-8")
  end

  def rentfee
    xpath = "/html/body/div[1]/div[2]/form[1]/div[6]/div/div/table/tbody/tr[1]/td/div[2]/span[1]/span[1]"
    return doc.xpath(xpath).text.delete(",").to_i
  end

  def managementfee
    xpath = "/html/body/div[1]/div[2]/form[1]/div[6]/div/div/table/tbody/tr[1]/td/div[2]/span[1]/span[3]"
    return doc.xpath(xpath).text.delete(",").delete("¥").to_i
  end
  
  def sikikin
    xpath = '/html/body/div[1]/div[2]/form[1]/div[6]/div/div/table/tbody/tr[1]/td/div[2]/span[2]/span[2]'
    return huyou_to_zero(doc.xpath(xpath).text)
  end
  
  def hosyokin
    xpath = '/html/body/div[1]/div[2]/form[1]/div[6]/div/div/table/tbody/tr[1]/td/div[2]/span[2]/span[3]'
    return huyou_to_zero(doc.xpath(xpath).text)
  end

  private

  # 不要を0に変換
  def huyou_to_zero(data)
    return 0 if data.include?('不要')
  end

end
  
