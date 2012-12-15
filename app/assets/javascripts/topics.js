//= require jquery
//= require jquery_ujs
// = require bootstrap-alert
// = require jquery.ui.autocomplete
$(function () {
	function reverse(s){
	    return s.split("").reverse().join("");
	}
	function rl(str){
		reverse(unescape(str))
	}
    $("#q").autocomplete({
        source: '/topics/auto_complete',
        select: function(event, ui) {
        	if (ui.item.value == "0") return false;
        	window.location.href = "/topics/" + ui.item.value
        }
    });
    val = $('#q').attr('value')
    // str = window.location.hostname.match(/^\w+/)[0]
    if(val !== ''){
		$.post("/topics/"+val+"/visit")
		if($('.waiting').length > 0){
			$('.waiting').each(function(){
				fname = $(this).attr("id")
				$(this).load("/topics/"+encodeURI(val)+"/fetch",{
					"fname": fname
				})
			})
		}
		
	}
	
	
})

function check_weibo(id,n){
  $.post("/topics/load_data",{'id': id,'n': n},function(){
  
  })
}
