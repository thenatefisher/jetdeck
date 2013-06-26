Jetdeck.Views.Delete ||= {}

class Jetdeck.Views.Delete.ShowDelete extends Backbone.View
  template: JST["templates/delete/delete"]

  events:
    "click #delete-section"     : "toggleDeleteMessage"
    "click #delete-confirm"     : "delete"
    "click .delete-cancel"      : "toggleDeleteMessage"
    
  delete: () ->
    if @$("#delete-confirmation-text").html() == "DELETE"
      @model.destroy()
      mixpanel.track("Deleted " + @model.get("type"), {}, ->
        window.location.href = "/" +  @model.get("type").toLowerCase() + "s"
      )
    else
      @$(".help-message").html("Type DELETE to confirm.").show()
    
  toggleDeleteMessage: ->
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
    return this
