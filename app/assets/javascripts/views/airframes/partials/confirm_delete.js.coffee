Jetdeck.Views.Airframes ||= {}

class Jetdeck.Views.Airframes.ConfirmDelete extends Backbone.View
  template: JST["templates/airframes/partials/confirm_delete"]
  
  events:
    "click .confirm_remove_spec"  : "delete"
  
  delete: ->
    @model.destroy()
    mixpanel.track("Deleted Airframe", {}, ->
      window.location.href = "/"
    )
    
  render: ->
    $(@el).html(@template() )
    return this
