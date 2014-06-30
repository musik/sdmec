#encoding: utf-8
require 'open-uri'
module TaobaoHelper
  def cache_open url
    cache url do
      open(url).read
    end
  end
  def find_shopurl_by_nick nick
    url = "http://s.taobao.com/search?q=#{CGI.escape(nick)}&app=shopsearch"
    data = cache_open(url)
    match = data.match(/\s+<span class="H">#{nick}<\/span>/)
    match = data.match(/href="(http:\/\/[\w\d]+.(taobao|tmall).com)">\s+<span class="H">#{nick}<\/span>/)
    match.present? ? match[1] : nil
  end
  def parse_shop_by_url url
    items_url = url + "/search.htm?orderType=hotsell_desc"
    #items_url = url + "/search.htm?orderType=price_desc"
    data = cache_open(items_url)
    if data.match(/版权所有TMALL.COM/).present?
      parse_tmall_shop data
    else
      parse_taobao_shop data
    end
  end
  def parse_taobao_shop html
    patts = {
      shop_id: '"shopId": "(\d+)"',
      userid: 'userId: "(\d+)"',
      nick: '"user_nick": "(.+?)"',
      realurl: 'href="(http://[\w\d]+?.taobao.com)" target="_blank" class="logo-extra iconfont',
      name: 'class="shop-name" href=".+?"><span>(.+?)<\/span><\/a>',
    }
    data = {}
    patts.each do |k,v|
      data[k] = html.match(Regexp.new(v))[1] rescue nil
    end
    data[:nick] = CGI.unescape(data[:nick]) if data[:nick].present?
    data.merge!(xiaoliang: 0,xse: 0, label: nil,items: [])
    data.merge!(parse_taobao_items(html)) # rescue nil
    data
  end
  def parse_taobao_items html
    doc = Nokogiri::HTML(html)
    items = []
    xiaoliang = 0
    xse = 0
    label = nil
    doc.css('#J_ShopSearchResult .item').each do |node|
      link = node.at_css('a.item-name')
      next if link.nil?
      item = {
        title: link.text().strip,
        url: link.attr("href"),
        price: node.at_css('.c-price').text().strip.to_f,
        vol: node.at_css('.sale-num').text().to_i,
      }
      label = node.at_css('.sale-num').previous().text().sub('：','') if label.nil?
      item[:xse] = (item[:price] * item[:vol]).round(2)
      items << item
      xiaoliang += item[:vol]
      xse += item[:xse]
    end
    items = items[0,60]
    #items = items.sort{|b,a| a[:xse] <=> b[:xse]}
    {xiaoliang: xiaoliang,xse: xse,label: label,items: items}
  end
  def parse_tmall_shop html
    patts = {
      shop_id: '"shopId": "(\d+)"',
      #name: '"name": "(.+?)"',
      userid: 'sellerId: "(\d+)"',
      nick: '"user_nick": "(.+?)"',
      realurl: 'slogo-shopname" href="(http:\/\/(.+?).tmall.com)"',
      name: 'class="slogo-shopname" href=".+?">(.+?)</a>',
    }
    data = {}
    patts.each do |k,v|
      data[k] = html.match(Regexp.new(v))[1] rescue nil
    end
    data[:nick] = CGI.unescape(data[:nick]) if data[:nick].present?
    data.merge! parse_tmall_items(html)
    data
  end
  def parse_tmall_items html
    doc = Nokogiri::HTML(html)
    items = []
    xiaoliang = 0
    xse = 0
    label = nil
    doc.css('.item').each do |node|
      link = node.at_css('a.item-name')
      item = {
        title: link.text().strip,
        url: link.attr("href"),
        price: node.at_css('.c-price').text().strip.to_f,
        vol: (node.at_css('.sale-num').text().to_i rescue 0),
      }
      label = (node.at_css('.sale-num').previous().text().sub('：','') rescue false) if label.nil?
      item[:xse] = (item[:price] * item[:vol]).round(2)
      items << item
      xiaoliang += item[:vol]
      xse += item[:xse]
    end
    items = items[0,60]
    items = items.sort{|b,a| a[:xse] <=> b[:xse]}
    {xiaoliang: xiaoliang,xse: xse,label: label,items: items}
  end
end
