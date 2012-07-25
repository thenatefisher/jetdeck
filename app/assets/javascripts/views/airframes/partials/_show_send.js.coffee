Jetdeck.Views.Airframes ||= {}

class Jetdeck.Views.Airframes.ShowSend extends Backbone.View
  template: JST["templates/airframes/partials/_send"]

  events :
    "click #send_spec" : "send"

  send : ->
    email = $("#recipient_email").val()
    $.post("/xspecs", {"xspec[recipient_email]": email, "xspec[airframe_id]": @model.get("id")})
    .success( (m) =>
      @$(".control-group").removeClass("error")
      @$(".help-inline").hide()
      if (m.recipient.id)
        new_lead = {
          email : m.recipient.email
          id : m.recipient.id
          xspecId: m.id
          url: "/s/" + m.urlCode
        }

        if m.recipient.first && m.recipient.last
          new_lead.name = m.recipient.first + " " + m.recipient.last

        @model.leads.add(new_lead)
        window.router.view.widgets.leads.render()
    )
    .error( (m) =>
      @$(".control-group").addClass("error")
      @$(".help-inline").show()
    )

  render : ->
    $(@el).html(@template(@model.toJSON() ))
    return this

