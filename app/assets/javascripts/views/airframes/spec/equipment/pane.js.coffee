Jetdeck.Views.Airframes ||= {}

# This is a pane inside the specification tab container

class Jetdeck.Views.Airframes.ShowEquipmentPane extends Backbone.View
  template: JST["templates/airframes/spec/equipment/pane"]

  events:
    "click .add-equipment"         : "addEquipment"

  addEquipment : =>
    c = new Jetdeck.Collections.EquipmentCollection()
    eq = c.create({
        airframe_id: @model.get("id")
        title: null,
        name: $(".equipment-name", @el).val()
        etype: 'equipment'
      }, 
      success: (c) =>
        @model.equipment.add(c)
        window.router.view.spec.equipment.render()
    )

  render: ->
    $(@el).html(@template() )

    if @model.equipment.where({etype: 'equipment'}).length > 0
      n = new Jetdeck.Views.Equipment.New(model: @model)
      $(@el).html(n.render().el)
    
    for item in @model.equipment.where({etype: 'equipment'})
      v = new Jetdeck.Views.Equipment.Item(model: item)
      $(@el).append(v.render().el)
      
    return this

