Jetdeck.Views.Contacts ||= {}

class Jetdeck.Views.Contacts.ShowSend extends Backbone.View
  template: JST["templates/contacts/partials/send"]

  events :
    "click #send_spec" : "send"

  send : ->

    @$("#send_spec").button('loading')
    email = @model.get("email")
    spec = $("#send_spec_id").val()
    send = true
    
    if $("#send_config").is(":checked")
      send = false

    $.post("/xspecs", {
    
      "xspec[recipient_email]"  : email, 
      "xspec[airframe_id]"      : spec,
      "xspec[send]"             : send
      
    }).success( (m) =>
    
      @$("#send_spec").button('reset')
      @$(".control-group").removeClass("error")
      @$(".help-inline").hide()
      
      ###
      if (m.recipient.id)
        new_lead = {
          email : m.recipient.email
          id : m.recipient.id
          xspec_id: m.id
          url: "/s/" + m.url_code
        }

      if m.recipient.first && m.recipient.last
        new_lead.name = m.recipient.first + " " + m.recipient.last

      @model.leads.add(new_lead)
      window.router.view.render()
      ###

      if (!send)
        specModel = new Jetdeck.Models.Spec(m)
        specModel.collection = new Jetdeck.Collections.SpecsCollection()
        specView = new Jetdeck.Views.Spec.EditView(model: specModel)
        modal(specView.render().el)
        mixpanel.track("Created Spec", {success: true})
      else
        mixpanel.track("Sent Spec", {success: true, is_new: true})
     
    ).error( (m) =>
      
      if $.parseJSON(m.responseText).recipient
        @$(".help-inline").html("Recipient " + $.parseJSON(m.responseText).recipient[0])
      
      if $.parseJSON(m.responseText).sender
        @$(".help-inline").html($.parseJSON(m.responseText).sender[0])
              
      @$("#send_spec").button('reset')
      @$(".control-group").addClass("error")
      @$(".help-inline").show()
      mixpanel.track("Created Spec", {success: false})
      
    )

  render : ->
    $(@el).html(@template(@model.toJSON() ))
    
    @$("#send_spec_val").autocomplete({
       minLength: 2
       autofocus: true
       focus: (event, ui) =>
          if ui.item.to_s && ui.item.id
            string_val = ui.item.to_s
            string_val = ui.item.to_s + " (" + ui.item.serial + ")" if ui.item.serial
            string_val = ui.item.to_s + " (" + ui.item.registration + ")" if ui.item.registration
            $("#send_spec_val").val(string_val) 
            $("#send_spec_id").val(ui.item.id)
          event.preventDefault()
       select: ( event, ui ) =>
          console.log ui.item
          if ui.item.to_s && ui.item.id
            string_val = ui.item.to_s
            string_val = ui.item.to_s + " (" + ui.item.serial + ")" if ui.item.serial
            string_val = ui.item.to_s + " (" + ui.item.registration + ")" if ui.item.registration
            $("#send_spec_val").val(string_val) 
            $("#send_spec_id").val(ui.item.id)
          return false          
       source: "/airframes/search_deck"
    }).data("autocomplete")._renderItem = ( ul, item ) ->
       ul.addClass("dropdown-menu")
       ul.addClass("typeahead")
       string_val = "<a><strong>" + item.to_s + "</strong></a>"
       string_val = "<a><strong>" + item.to_s + "</strong> " + item.serial + "</a>" if item.serial  
       string_val = "<a><strong>" + item.to_s + "</strong> " + item.registration + "</a>" if item.registration       
       return $( "<li class=\"result\" style=\"cursor: pointer\"></li>" )
	        .data( "item.autocomplete", item )
	        .append( string_val )
	        .appendTo( ul )
    return this

