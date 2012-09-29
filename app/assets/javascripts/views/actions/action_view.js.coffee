Jetdeck.Views.Actions ||= {}

class Jetdeck.Views.Actions.ActionView extends Backbone.View
  template: JST["templates/actions/action"]

  events: 
    "click .close-action" : "close"
    
  close: =>
    @model.save({is_completed: true}, success: => $(@el).fadeOut(); mixpanel.track("Closed Action"))
  
  initialize: ->
    $(@el).hover( 
      => 
        @$(".action-buttons").show()
        @$(".long-title").show()
        @$(".short-title").hide()
      ,
      => 
        @$(".action-buttons").hide()
        @$(".long-title").hide()
        @$(".short-title").show()
    )
  
  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
