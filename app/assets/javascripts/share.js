$(function () {
	
	
	if($('#livestream').length > 0){
		q = $('#livestream').text()
		if(q == '')
			q = $('#q').attr('value')
		q = encodeURI(q)
		$('#livestream').html("<iframe width='100%' height=600 frameborder=0 scrolling='no' src='http://widget.weibo.com/livestream/listlive.php?language=zh_cn&width=0&height=600&uid=1706312214&skin=1&refer=1&appkey=1205190349&pic=0&titlebar=0&border=1&publish=0&atalk=1&recomm=0&at=0&atopic="+q+"&ptopic="+q+"&dpc=1'>")
	}
	if($('#pinglunxiang').length > 0){
		var url = "http://widget.weibo.com/distribution/comments.php?width=0&url="+encodeURI($('head link[rel=canonical]').attr("href"))+"&brandline=y&appkey=1205190349&dpc=1";
		$('#pinglunxiang').html('<iframe id="WBCommentFrame" src="' + url + '" scrolling="no" frameborder="0" style="width:100%"></iframe>');
		$.getScript('http://tjs.sjs.sinajs.cn/open/widget/js/widget/comment.js', function(data, textStatus, jqxhr) {
		   window.WBComment.init({
			    "id": "WBCommentFrame"
			});
		});			
	}
})