Jetdeck.Views.Invites ||= {}

class Jetdeck.Views.Invites.NewView extends Backbone.View
  template: JST["templates/invites/new"]

  events:
    "click #invite-send": "save"

  save: =>

    @$("#invite-send").button('loading')

    collection = new Jetdeck.Collections.InvitesCollection()
    model = new Jetdeck.Models.InviteModel()
    
    model.set({
      message: @$("textarea").val(),
      email: @$("input[name='email']").val(),
      name: @$("input[name='name']").val()
    })
    
    collection.create(model.toJSON(),
      success: (i) =>
        mixpanel.track("Sent Invite", {}, =>
          @$("#invite-send").button('reset')
          # update invite count
          $("#invite-count").html(i.get("invites"))
          if i.get("invites") == 0
            $("#invite-sidebar").hide()
          modalClose()
        )

      error: (m, j) =>
      
        @$("#invite-send").button('reset')
      
        if $.parseJSON(j.responseText).email
          @$(".email_group").children(".help-block").html("Recipient " + $.parseJSON(j.responseText).email[0])
        
        if $.parseJSON(j.responseText).sender
          @$(".email_group").children(".help-block").html($.parseJSON(j.responseText).sender[0])
        
        @$(".email_group").addClass("error")
        @$(".email_group").children(".help-block").removeClass("hide")

    )
    
    

  render: ->
    $(@el).html(@template( ))
    return this
