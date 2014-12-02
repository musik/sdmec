# -*- encoding : utf-8 -*-
module ApplicationHelper
  def sogou id,width,height
"<script type=\"text/javascript\">
var sogou_ad_id=#{id};
var sogou_ad_height=#{height};
var sogou_ad_width=#{width};
</script>
<script language='JavaScript' type='text/javascript' src='http://images.sohu.com/cs/jsfile/js/c.js'></script>".html_safe
  end
  def _set_xtao_cookie
    #signs = TaobaoFu.generate_xtao_sign
    signs = _generate_xtao_sign
    cookies[:timestamp] = signs[:timestamp]
    cookies[:sign] = signs[:sign]
  end
  def _generate_xtao_sign
    timestamp = "#{Time.now.to_i}000"
    settings={
    'app_key' => 12060575,
    'secret_key' => 'afd5f5c495f921f9e42470db179cfd1f'
    }
    param_string = {"app_key"=>settings['app_key'],"timestamp"=>timestamp}.flatten.join
    param_string = sprintf("%1$s%2$s%1$s",settings['secret_key'],param_string)
    {:timestamp=>timestamp,:sign=>Digest::HMAC.hexdigest(param_string,settings['secret_key'],Digest::MD5).upcase}
  end
  def baidu_clb id
    #javascript_tag("BAIDU_CLB_fillSlot(#{id});") if Rails.env.production?
  end
  def adsense slot,name,args={}
    defaults={
      :width => 336,
      :height => 280,
      :slot => slot,
      :name => name
    }
    render :partial=>'layouts/adsense',:locals=>defaults.merge(args)
  end
  def slotb
    #rand(2) > 0 ?
      #"<div class='slot' id='slotb'></div>".html_safe :
        #adsense('3040110643','sd-shop-before')
      #("<div class='bdct'>" + bdad('SD5200-SHOP-BEFORE，2012-12-5',1151174) + "</div>").html_safe
  end
  def slotf
    #rand(2) > 0 ?
      #"<div class='slot' id='slotf'></div>".html_safe :
        #adsense('5993577049','sd-shop-bottom')
  end
end
