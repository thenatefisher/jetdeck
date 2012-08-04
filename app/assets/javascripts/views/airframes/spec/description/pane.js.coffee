Jetdeck.Views.Airframes ||= {}

# This is a pane inside the specification tab container

class Jetdeck.Views.Airframes.ShowDescriptionPane extends Backbone.View
  template: JST["templates/airframes/spec/description/pane"]
  
  events:
    "change textarea"       : "edit" 
   
  edit: ->
    @model.set("description", @$("textarea").val())
    @model.save(false, 
      success: =>
        window.router.view.spec.description.render()
    )
    
  render: ->
    $(@el).html(@template(@model.toJSON() ) )
    
    return this
