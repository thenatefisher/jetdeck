this.modal = (content) ->
  if (content != "" && content != null) 
    $("#jetdeckModal").html(content)
    $("#jetdeckModal").modal()

this.modalClose = ->
  $("#jetdeckModal").modal('hide')
