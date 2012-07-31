Jetdeck.Views.Airframes ||= {}

# This is a pane inside the specification tab container
# The SpecPaneView doesn't display engines
class Jetdeck.Views.Airframes.ShowSpecPane extends Backbone.View
  template: JST["templates/equipment/spec_pane"]

  events:
    "click .removeEquipment"    : "removeEquipment"
    "click .addEquipment"       : "addEquipment"
    
  removeEquipment : (e) =>
    @model.equipment.remove(e)
    @model.save(null,
        success: =>
            @model.fetch( success: => @render())
    )
        
  addEquipment : (e) =>
    @model.equipment.push({id: e})    
    @model.save(null,
        success: =>
            @model.fetch( success: => @render())
    )
        
  render: =>
    data = Array()
    @model.equipment.forEach((i) =>
        if i.get('type') == @options.type
            data.push(i.toJSON())
    )
    $(@el).html(@template(equipmentItems: data ))
    return this
