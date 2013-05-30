$(->
  
    $("#navbar-search").autocomplete({
       minLength: 2,
       autofocus: true,
       focus: (event, ui) =>
          event.preventDefault(); 
       source: "/search",
       select: ( event, ui ) =>
          window.location.href = ui.item.url
          return false
    })
    .data("uiAutocomplete")._renderItem = ( ul, item ) ->
       ul.addClass("dropdown-menu");
       ul.addClass("typeahead");
       return $( "<li class=\"result\" style=\"cursor: pointer\"></li>" )
	        .data( "item.autocomplete", item )
	        .append( "<a href='" + item.url + "'><strong>" + item.label + "</strong><br>" + item.desc + "</a>" )
	        .appendTo( ul )  
	        
    $("#new-quicksend").tooltip({placement: "bottom", delay: { show: 500, hide: 100 }})
    $("#new-quicksend").click( ->
        #view = new Jetdeck.Views.Airframes.NewView()
        #$(".new-spec").popover('hide')
        #modal(view.render().el)
    )

    $("#new-spec").click( ->
        view = new Jetdeck.Views.Airframes.NewView()
        $(".new-spec").popover('hide')
        modal(view.render().el)
    )

    $("#new-contact").click( ->
        view = new Jetdeck.Views.Contacts.NewView()
        modal(view.render().el)
    )
    
    $("#new-invite").click( ->
        view = new Jetdeck.Views.Invites.NewView()
        modal(view.render().el)
    )    
    
    $(".dropdown-menu li").live('hover',
      (e) ->
        if (e.type == 'mouseenter') 
          $("i", this).addClass("icon-white")
        else 
          $("i", this).removeClass("icon-white")
    )
    
)