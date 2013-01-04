root.alertFailureTimeout = null
root.alertFailure = (content) ->
  if (content != "" && content != null) 
    $("#jetdeck-notification-error div.notification-content").html(content)
    $("#jetdeck-notification-error").fadeIn('fast')
    alertSuccessTimeout = setTimeout("alertFailureClose()", 2500)

root.alertFailureClose = ->
    $("#jetdeck-notification-error").fadeOut('fast')

root.alertSuccessTimeout = null
root.alertSuccess = (content) ->
  if (content != "" && content != null) 
    $("#jetdeck-notification div.notification-content").html(content)
    $("#jetdeck-notification").fadeIn('fast')
    alertSuccessTimeout = setTimeout("alertSuccessClose()", 2500)

root.alertSuccessClose = ->
  $("#jetdeck-notification").fadeOut('fast')