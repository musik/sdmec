//= require jquery
//= require jquery_ujs
// = require bootstrap-alert
// = require bootstrap-affix
//comment// = require jquery.ui.autocomplete
function reverse(s){
    return s.split("").reverse().join("");
}
function rl(str){
	return reverse(unescape(str));
}
function goto(url,o){
	if ($(o).attr("href") == "javascript://"){
		$(o).attr("href",reverse(unescape(url)))
		$(o).attr("target","_blank")
		$(o).attr("onclick","")
	}
}
function rewrite_link(str){
  console.debug(rl(str))
  $('.shoplink').attr('href',reverse(str))
}
$(function () {
  //$('#full1').html('<div class="container"><<img src="http://img02.taobaocdn.com/tps/i2/T1Gg.bXe0iXXbeBPzh-990-318.jpg"><img src="http://img03.taobaocdn.com/tps/i3/T1yXocXnFjXXaRrOzh-990-171.jpg" /></div>')
	$('a.rl').click(function(){
		$(this).attr("href",reverse(unescape($(this).attr('data'))))
		$(this).attr("target","_blank")
	})
  $('.content').before('<div id="slot1"><div>')

  $('#details-section').before('<div id="slotb"></div>')
  $('#reviews-section').after('<div id="slotf"></div>')
  $.getScript('http://cbjs.baidu.com/js/m.js',function(){
    //BAIDU_CLB_fillSlotAsync('503903','full1')
    BAIDU_CLB_fillSlotAsync('484907','slotb')
    BAIDU_CLB_fillSlotAsync('484908','slotf')
  })
  $('#contact-note').html('以下为网站联系方式，用于网安/主机商/机房联系处理敏感内容，或其它各界与网站有关的诸如交换链接/意见反馈等用途。<br />此联系方式与本页可能展示的淘宝店铺无关。<br><span class="badge badge-important"> 敏感内容联系</span>0874-3335702 18087409631&nbsp;'+'<span class="badge badge-info">QQ</span><a target="_blank" href="http://sighttp.qq.com/authd?IDKEY=f62e57b812e5ba6bcabb95e781a841ed8edb5efa46c90997">58265826</a>&nbsp;'+'<span class="badge badge-success">Email</span>admin@sdmec.com')
})
function loadFull(){
  $('body').html('<iframe frameborder="0" marginheight="0" marginwidth="0" border="0" id="alimamaifrm" name="alimamaifrm" scrolling="no" height="2432px" width="100%" src="http://www.taobao.com/go/chn/tbk_channel/channelcode.php?pid=mm_10894158_2495491_10853963&eventid=101329" ></iframe>').prepend('<div id="bookmark" data-area="top_add_fav">为保证购物安全 <a class="taf_add" target="_self" href="javascript:AddFavorite(window.location.href,document.title)">收藏淘店铺</a> 正品保证，安全购物！ ')
}
function appendFull(){
  return ;
  $('#main').after('<iframe frameborder="0" marginheight="0" marginwidth="0" border="0" id="alimamaifrm" name="alimamaifrm" scrolling="no" height="2432px" width="100%" src="http://www.taobao.com/go/chn/tbk_channel/channelcode.php?pid=mm_10894158_2495491_10853963&eventid=101329" ></iframe>')
}
function track_store_click(id,title,act){
  _gaq.push(['_trackEvent',act,title,"http://shop" + String(id) + ".taobao.com"])
}
function track_store_action(id,gaq,act){
  gaq.push(['_trackEvent','store',act,"http://shop" + String(id) + ".taobao.com"])
}
function track_store_visit(id,gaq){
  gaq.push(['_trackEvent','store','link',"http://shop" + String(id) + ".taobao.com"])
}
function track_search_visit(id,gaq){
  gaq.push(['_trackEvent','search','link',id])
}
function track_top_ad(){
  //console.debug(window.location.href)
  _gaq.push(['_trackEvent','topad','click',window.location.href])
}
function link_load(id,link_id){
  $(id).load('/links/' + String(link_id) + '.json',function(){
    $('#mingdian a').click(function(){
      _gaq.push(['_trackEvent','mingdian','click',$(this).attr('href')])
      _gaq.push(['_trackEvent','mingdian','name',$(this).text()])
    })
  })
}
function convert_shop(nick,context,valueable){
    fields = valueable ? 'click_url,commission_rate' : 'user_id,click_url,commission_rate,seller_credit,shop_type,total_auction,auction_count' 
    TOP.api('rest', 'get',{
      method:'taobao.taobaoke.widget.shops.convert',
      'fields': fields,
      seller_nicks: nick,
      outer_code: context
    },function(resp){
      if(resp.error_response){
        console.debug('Fail:taobao.taobaoke.widget.shops.convert'+resp.error_response.msg);
        return false;
       }
       //console.debug(resp)
       if(typeof(resp.taobaoke_shops) != "undefined"){
         var respShop=resp.taobaoke_shops.taobaoke_shop[0];
         $('.shoplink').attr('href',respShop.click_url)
         if(valueable == false){
           var args = $('#shoplink').attr('onclick').match(/(\d+),\'(.+?)\'/)
            _gaq.push(['_trackEvent','tovalue',args[2],"http://shop" + args[1] + ".taobao.com"])
         }
       }else{
         if(valueable){
           var args = $('#shoplink').attr('onclick').match(/(\d+),\'(.+?)\'/)
            _gaq.push(['_trackEvent','tofree',args[2],"http://shop" + args[1] + ".taobao.com"])
         }
       }
    })  
  //})
}
function load_items(id){ 
  $.get('/shop/' + String(id) + '/items.js',{update:true})
}
