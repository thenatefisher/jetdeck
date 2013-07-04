Jetdeck.Views.Delete ||= {}

class Jetdeck.Views.Delete.ShowDelete extends Backbone.View
  template: JST["templates/delete/delete"]

  events:
    "click #delete-section"     : "toggleDeleteMessage"
    "click #delete-confirm"     : "delete"
    "click .delete-cancel"      : "toggleDeleteMessage"
    
  delete: () ->
    if @$("#delete-confirmation-text").val() == "DELETE"
      type = /\/(.*)s/.exec(@model.url)[1]
      @model.destroy()
      mixpanel.track("Deleted " + type, {}, ->
        window.location.href = "/" +  type.toLowerCase() + "s"
      )
    else
      @$(".help-message").html("Type DELETE to confirm.").show()
    
  toggleDeleteMessage: ->
    @$("#delete-confirmation-text").html("")
    if $("#delete-button").is(":visible")
      $("#delete-button").hide()
      $("#delete-section").show()
    else
      $("#delete-button").show()
      $("#delete-section").hide()
    return false

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    @$(".help-message").hide()
    @$("#delete-confirmation-text").keyup( (event) =>
      if(event.keyCode == 13)
        @delete()
    )
    return this
