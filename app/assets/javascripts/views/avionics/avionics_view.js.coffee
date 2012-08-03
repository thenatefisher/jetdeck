Jetdeck.Views.Avionics ||= {}

class Jetdeck.Views.Avionics.Item extends Backbone.View
  template: JST["templates/airframes/spec/avionics/item"]   

  className: "equipment_item"
  
  events:
    "click .remove_equipment" : "removeEquipment" 
    "change .equipment"       : "edit" 
   
  edit: (event) ->
    e = event.target || event.currentTarget
    value = $(e).val()
    name = $(e).attr('name')
    @model.set(name, value)
    @model.save(false, 
      success: =>
        window.router.view.spec.avionics.render()
    )
    
  removeEquipment : =>
    @model.destroy(
      success: =>
        window.router.view.spec.avionics.render()
    )
    
  render: =>
    $(@el).addClass("pull-left equipment-item")
    
    $(@el).html(@template($.extend( {margin: @options.margin}, @model.toJSON() )))
    
    @$(".remove_equipment").hover(
      -> $(this).addClass("dark_color"),
      -> $(this).removeClass("dark_color")
    )
    
    return this
    
class Jetdeck.Views.Avionics.New extends Backbone.View
  template: JST["templates/airframes/spec/avionics/new"]   
  
  render: =>
    $(@el).html(@template())
    return this  
