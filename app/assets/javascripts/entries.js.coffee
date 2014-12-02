@entry_check = (domain) ->
  $.post("/websites/"+domain+ "/check")
