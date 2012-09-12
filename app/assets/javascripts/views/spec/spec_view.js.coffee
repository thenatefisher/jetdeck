Jetdeck.Views.Specs ||= {}

class Jetdeck.Views.Specs.SpecView extends Backbone.View
  template : JST["templates/contacts/specs/item"]
  
  tagName : "tr"
      
  render : ->
    $(@el).html(@template(@model.toJSON() ))
    return this       
