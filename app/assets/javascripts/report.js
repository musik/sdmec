// = require jquery.ui.datepicker

$(function() {
    $( "#datepicker" ).datepicker({
      dateFormat: "yymmdd",
      onSelect: function(dateText,inst){
        window.location.href = "/reports?date=" + dateText
        console.log(dateText)
        console.log(inst)
      }
    });
});
