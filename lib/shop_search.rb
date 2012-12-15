#encoding: utf-8
class ShopSearch 
  @queue = :shop_search
  def self.perform q,page
    keep_time 1 do
      ShopSearch.new.search q,page
    end
  end
  def run_all_categories
    Category.find_each do |c|
      async_search c.name
    end
  end

  def run_home
    url = 'http://shopsearch.taobao.com/search?v=shopsearch&q='
    response = Typhoeus::Request.get url,:user_agent=>"another 360 spider"

    if response.success?
      doc = Nokogiri::HTML(response.body,nil,'gbk')
      parse_shops doc
    else
      Rails.logger.debug response
    end
  end
  def search q,page=1,run_next=true
    url = "http://shopsearch.taobao.com/search?v=shopsearch&q=#{CGI.escape q.encode('GBK')}"
    response = Typhoeus::Request.get url,:user_agent=>"another 360 spider"

    if response.success?
      doc = Nokogiri::HTML(response.body,nil,'gbk')
      parse_shops doc
      #parse_qs doc
      return unless run_next
      has_next = !doc.at_css('a.page-next').nil?
      async_search(q,page+1) if has_next
    else
      Rails.logger.debug response
    end
  end
  def async_search q,page=1
    Resque.enqueue(ShopSearch,q,page)
  end
  def parse_qs doc
    doc.css('#J_Navgation dl').each do |dl|
      title = dl.at_css('dt').text()
      next unless %w(品牌).include? title
      dl.css('li span').each do |span|
        pp span.children[0].text()
      end
    end
  end
  def parse_shops doc
    doc.css('.list-item').each do |item|
      uname = item.at_css('.shop-info-list a').text()
      city_name = item.at_css('.list-place span').text().split(' ').pop
      Store.import_by_uname_and_cityname uname,city_name
    end
  end
end

