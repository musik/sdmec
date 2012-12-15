# -*- encoding : utf-8 -*-
%w(pp nokogiri).each do |p| 
  require p 
end
class ImportCities
  def run
    City.delete_all
    run_homepage
    # pp City.group(:parent_id).select(:parent_id).count
    pp City.count
    # City.where(['zhixiashi = ? or parent_id > 0',true]).each do |c|
      # fetch_page c.slug,c.id
    # end
    # pp City.count
  end
  def run_homepage
    root = 'http://www.qu114.com/city.aspx'
    res = Typhoeus::Request.get(root)
    doc = Nokogiri::HTML(res.body)
    
    doc.css('dl.noArea')[1].at_css('dd').css('a').each do |a|
      pp City.create :name=>a.text,:slug=>a.attribute("href").to_s.scan(/\/(\w+)\./)[0][0],:zhixiashi=>true,:parent_id=>0,:use_subdomain=>true
    end
    doc.css('.contentr dl').each do |dl|
      dta = dl.at_css('dt a')
      next if dta.nil?
      c = City.create :name=>dta.text,:slug=>dta.attribute("href").to_s.scan(/\/(\w+)\/$/)[0][0],:parent_id=>0,:use_subdomain=>true
      pp c
      dl.at_css('dd').css('a').each do |a|
        pp City.create :name=>a.text,:slug=>a.attribute("href").to_s.scan(/\/(\w+)\./)[0][0],:parent_id=>c.id,:use_subdomain=>true
      end
    end
  end
  def fetch_page subdomain,cid = 0
    url = "http://#{subdomain}.qu114.com/waiyupeixun/"
    res = Typhoeus::Request.get(url)
    doc = Nokogiri::HTML(res.body)
    doc.at_css('#Qu114Address table dl').css('dd')[1].css('a').each do |a|
      next if %w(不限 其他 其它).include? a.text
      slug = a.attribute("href").to_s.scan(/\/(\w+)/)[0][0]
      next if slug =~ /zhoubian$/
      pp City.create :name=>a.text,:slug=>a.attribute("href").to_s.scan(/\/(\w+)/)[0][0],:parent_id=>cid,:use_subdomain=>false
    end
  end
end
