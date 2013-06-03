Jetdeck.Views.Send ||= {}

class Jetdeck.Views.Send.ShowSend extends Backbone.View
  template: JST["templates/airframes/partials/send_temp"]

  events :
    "click #send_spec" : "send"

  send : ->

    @$("#send_spec").button('loading')
    email = $("#recipient_email").val()
    send = true
    
    if $("#send_config").is(":checked")
      send = false

    $.post("/xspecs", {
    
      "xspec[recipient_email]"  : email, 
      "xspec[airframe_id]"      : @model.get("id"),
      "xspec[send]"             : send
      
    }).success( (m) =>
    
      @$("#send_spec").button('reset')
      @$(".control-group").removeClass("error")
      @$(".help-inline").hide()
      
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

      if (!send)
        specModel = new Jetdeck.Models.SpecModel(m)
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
    
    @$("#recipient_email").autocomplete({
       minLength: 2
       autofocus: true
       focus: (event, ui) =>
          $("#recipient_email").val(ui.item.value) if ui.item.value
          event.preventDefault()
       select: ( event, ui ) =>
          $("#recipient_email").val(ui.item.value) if ui.item.value
          return false          
       source: "/contacts/search"
    }).data("uiAutocomplete")._renderItem = ( ul, item ) ->
       ul.addClass("dropdown-menu")
       ul.addClass("typeahead")
       return $( "<li class=\"result\" style=\"cursor: pointer\"></li>" )
	        .data( "item.autocomplete", item )
	        .append( "<a><strong>" + item.label + "</strong></a>" )
	        .appendTo( ul )
    return this

