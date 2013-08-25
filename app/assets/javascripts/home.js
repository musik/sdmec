//= require jquery
//= require jquery_ujs
// = require bootstrap-alert
//= require jquery.ui.autocomplete
$(function () {
    $("#hq").autocomplete({
        source: '/tags/auto_complete',
        focus: function(){
          return false;
        },
        select: function(event, ui) {
          if (ui.item.value == "0") return false;
          window.location.href = ui.item.value
          return false
        }
    });
})
