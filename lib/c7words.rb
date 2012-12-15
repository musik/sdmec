# -*- encoding : utf-8 -*-
class C7words
  
  def run
    page = 1
    max = 2
    links = []
    while page <= max
      url = "http://www.7c.com/baidu/sdmec.com/2/#{page}/"
      res = Typhoeus::Request.get url
      doc = Nokogiri::HTML res.body
      i= 0
      doc.at_css('table.sop').css('tr').each do |tr|
        i+=1
        next if i == 1
        link= {}
        link[:text]=tr.css('td a')[0].content
        link[:href]=tr.css('td a')[1].attr('href')
        links << link
      end
      page +=1
    end
    txt=""
    links.each do |l|
      #txt += "<a href=\"#{l[:href]}\">#{l[:text]}</a>\n\r"
      txt += "=link_to \"#{l[:text]}\",\"#{l[:href]}\"\n\r"
    end
    puts txt
  end
  def test
    url = 'https://login.taobao.com/member/login.jhtml'
    params = {
      "TPL_username" => 'usedcar',
      'TPL_password' => 'semrush2',
      'action' => 'Authenticator',
      'TPL_redirect_url' => 'http://lz.taobao.com/login/?_back=%2f'
    }
    res = Typhoeus::Request.post url,params
    # File.open("#{Rails.root}/public/test.html",'w'){|f| f.write res.body  }
    require 'iconv'
    pp Iconv.iconv res.body,'GBK','UTF-8'
  end
end
