Jetdeck.Views.Equipment ||= {}
    
class Jetdeck.Views.Equipment.New extends Backbone.View
  template: JST["templates/airframes/spec/equipment/new"]   
  
  render: =>
    $(@el).html(@template())
    return this  
