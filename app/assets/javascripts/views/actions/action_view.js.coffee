Jetdeck.Views.Actions ||= {}

class Jetdeck.Views.Actions.ActionView extends Backbone.View
  template: JST["templates/actions/action"]

  initialize: ->
    $(@el).click( => 
      window.location.href = @model.get("url")
    )
    
    $(@el).hover( 
      => 
        @$(".long-title").show()
        @$(".short-title").hide()
      ,
      => 
        @$(".long-title").hide()
        @$(".short-title").show()
    )
  
  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
