this.alertFailureTimeout = null
this.alertFailure = (content) ->
  if (content != "" && content != null) 
    $("#jetdeck-notification-error div.notification-content").html(content)
    $("#jetdeck-notification-error").fadeIn('fast')
    alertSuccessTimeout = setTimeout("alertFailureClose()", 2500)

this.alertFailureClose = ->
    $("#jetdeck-notification-error").fadeOut('fast')

this.alertSuccessTimeout = null
this.alertSuccess = (content) ->
  if (content != "" && content != null) 
    $("#jetdeck-notification div.notification-content").html(content)
    $("#jetdeck-notification").fadeIn('fast')
    alertSuccessTimeout = setTimeout("alertSuccessClose()", 2500)

this.alertSuccessClose = ->
  $("#jetdeck-notification").fadeOut('fast')