//= require jquery
//= require jquery_ujs
// = require bootstrap-alert
// = require bootstrap-affix
//

function add_item(num_iid){
  $.post('/items/add',{item: items[num_iid]})
}
function remove_item(id){
  $.ajax({
      url: '/items/' + String(id),
      type: 'DELETE'
  })
}
function add_shop(user_id){
  $.post('/shops/add',{shop: shops[user_id]})
}
function remove_shop(id){
  $.ajax({
      url: '/shops/' + String(id),
      type: 'DELETE'
  })
}
function save_list(){
  var ids = []
  $('.shop-results tbody tr').each(function(i,obj){
    ids[i]=$(this).attr("id")
  })
  ids = ids.join(',').replace(/shopx-/g,'').split(',')
  $.post("/options",{"home_shop_ids": ids})
}
