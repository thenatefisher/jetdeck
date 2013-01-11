$(->

    $('#beta').popover({
      animation: true
      placement: "bottom"
      trigger: "hover"
      title: "JetDeck is a Beta!"
      content: "This means it's not a commercial product yet and may have a few bugs here and there. We appreciate your feedback when something isn't perfect. In exchange for any inconvenience, you get to use all the features of JetDeck for free while we keep making it better. Fair trade, right?"
    })
    
    $("#navbar-search").autocomplete({
       minLength: 2,
       autofocus: true,
       focus: (event, ui) =>
          #$(".select2-choice").children("span").html("<a href='" + ui.item.url + "'><strong>" + ui.item.label + "</strong><br>" + ui.item.desc + "</a>" )
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