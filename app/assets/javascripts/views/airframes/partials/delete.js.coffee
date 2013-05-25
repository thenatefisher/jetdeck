Jetdeck.Views.Airframes ||= {}

class Jetdeck.Views.Airframes.ShowDelete extends Backbone.View
  template: JST["templates/airframes/partials/delete"]

  events:
    "click #delete-section"     : "toggleDelete"
    "click #delete-confirm"     : "delete"
    "click .delete-cancel"      : "toggleDelete"
    
  delete: () ->
    @model.destroy()
    mixpanel.track("Deleted Airframe", {}, ->
      window.location.href = "/"
    )
    
  toggleDelete: ->
  
    if $("#delete-button").is(":visible")
      $("#delete-button").hide()
      $("#delete-section").show()
    else
      $("#delete-button").show()
      $("#delete-section").hide()

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
