# -*- encoding : utf-8 -*-
class TaobaoTop
  def initialize 
    @base = 'http://top.taobao.com/'
  end
  def run
    get_cats
  end
  def get_cats
    doc = fetch @base
    doc.at_css('#nav').css('li > a').each do |a|
      next if a.text == '首页'
      c = Cat.where(:name=>a.text).first_or_create :oid=>href_to_oid(a.attr('href'))
      pp c if Rails.env.test?
      delay.get_root c
    end 
  end
  def href_to_oid str
    str.strip.match(/\=([\d\w\_]+)$/)[1]
  end
  def get_root root
    data = Typhoeus::Request.get("#{@base}interface2.php?cat=#{root.oid}").body
    require 'htmlentities'
    coder = HTMLEntities.new
    data = data.sub(/var \=/,'').sub(/\;$/,'')
    doc = Nokogiri::HTML(JSON.parse(data)["cats"])
    doc.css('dl').each do |dl|
      dt = dl.at_css('dt a')
      c = root.children.where(:name=>dt.text).first_or_create :oid=>href_to_oid(dt.attr('href'))
      pp c if Rails.env.test?
      
      if dl.css('dd').size >= 7
        delay.get_root c
      elsif dl.css('dd').size > 0
        dl.css('dd a').each do |a|
          cc = c.children.where(:name=>a.text).first_or_create :oid=>href_to_oid(a.attr('href'))
          delay.get_root cc
          pp cc if Rails.env.test?
        end
      end
    end
    
  end
  def run_keywords c
    %w(brand focus).each do |show|
      delay(:queue => 'cat',:priority=>2).get_show c,show,false
      delay(:queue => 'cat',:priority=>2).get_show c,show,true
    end
  end
  def get_show c,show="brand",up=false
    page = 0
    while 
      page+=1
      offset = (page-1)*30
      doc = fetch("#{@base}/level3.php?cat=#{c.oid}&show=#{show}&up=#{up}&offset=#{offset}")
      doc.at_css('.textlist').css('span.title').each do |n|
        t = Topic.where(:name=>n.at_css("a").text).first_or_create :volume=>n.parent.at_css("span.focus em").text.to_i
        # pp t if Rails.env.test?
      end
      break if doc.at_css('.pagination .page-bottom a.page-next').nil? 
    end
  end
  def fetch(url)
    res = Typhoeus::Request.get url
    pp url if Rails.env.test?
    Nokogiri::HTML(res.body) 
  end
end
