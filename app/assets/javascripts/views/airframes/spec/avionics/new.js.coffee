Jetdeck.Views.Avionics ||= {}
    
class Jetdeck.Views.Avionics.New extends Backbone.View
  template: JST["templates/airframes/spec/avionics/new"]   
  
  render: =>
    $(@el).html(@template())
    return this  
