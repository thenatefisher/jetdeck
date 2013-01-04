root.modal = (content) ->
  if (content != "" && content != null) 
    $("#jetdeckModal").html(content)
    $("#jetdeckModal").modal()

root.modalClose = ->
  $("#jetdeckModal").modal('hide')
