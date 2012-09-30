$(->
        
    $("#navbar-search").autocomplete({
       minLength: 2,
       autofocus: true,
       focus: (event, ui) =>
          $(".select2-choice").children("span").html("<a href='" + ui.item.url + "'><strong>" + ui.item.label + "</strong><br>" + ui.item.desc + "</a>" )
          event.preventDefault(); 
       source: "/search",
       select: ( event, ui ) =>
          window.location.href = ui.item.url
          return false
    })
    .data("autocomplete")._renderItem = ( ul, item ) ->
       ul.addClass("dropdown-menu");
       ul.addClass("typeahead");
       return $( "<li class=\"result\" style=\"cursor: pointer\"></li>" )
	        .data( "item.autocomplete", item )
	        .append( "<a href='" + item.url + "'><strong>" + item.label + "</strong><br>" + item.desc + "</a>" )
	        .appendTo( ul )  
	        
    $(".new-spec").click( ->
        view = new Jetdeck.Views.Airframes.NewView()
        $(".new-spec").popover('hide')
        modal(view.render().el)
    )

    $(".new-contact").click( ->
        view = new Jetdeck.Views.Contacts.NewView()
        modal(view.render().el)
    )
    
    $(".dropdown-menu li").live('hover',
      (e) ->
        if (e.type == 'mouseenter') 
          $("i", this).addClass("icon-white")
        else 
          $("i", this).removeClass("icon-white")
    )
    
    # bootstrap.js
    $("a[rel=popover]").popover()
    $(".tooltip").tooltip()
    $("a[rel=tooltip]").tooltip()
    
)

root = exports ? this

root.modal = (content) ->
  if (content != "" && content != null) 
    $("#jetdeckModal").html(content)
    $("#jetdeckModal").modal()

root.modalClose = ->
  $("#jetdeckModal").modal('hide')

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

root.editInline = (model, fname, value) ->
  model.set(fname, value)
  model.save(null)


