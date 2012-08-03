Jetdeck.Views.Equipment ||= {}

class Jetdeck.Views.Equipment.Item extends Backbone.View
  template: JST["templates/airframes/spec/equipment/item"]   

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
        window.router.view.spec.equipment.render()
    )
    
  removeEquipment : =>
    @model.destroy(
      success: =>
        window.router.view.spec.equipment.render()
    )
    
  render: =>
    $(@el).addClass("pull-left equipment-item")
    $(@el).html(@template(@model.toJSON() ))
    @$(".remove_equipment").hover(
      -> $(this).addClass("dark_color"),
      -> $(this).removeClass("dark_color")
    )    
    return this

