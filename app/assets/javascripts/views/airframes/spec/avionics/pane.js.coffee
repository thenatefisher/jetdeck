Jetdeck.Views.Airframes ||= {}

# This is a pane inside the specification tab container

class Jetdeck.Views.Airframes.ShowAvionicsPane extends Backbone.View
  template: JST["templates/airframes/spec/avionics/pane"]

  events:
    "click .add-equipment"         : "addEquipment"

  addEquipment : =>
    c = new Jetdeck.Collections.EquipmentCollection()
    eq = c.create({
        airframe_id: @model.get("id")
        title: $(".equipment-title", @el).val()
        name: $(".equipment-name", @el).val()
        etype: 'avionics'
      }, 
      success: (c) =>
        @model.equipment.add(c)
        window.router.view.spec.avionics.render()
    )

  render: ->
    $(@el).html(@template() )

    if @model.equipment.where({etype: 'avionics'}).length > 0
      n = new Jetdeck.Views.Avionics.New(model: @model)
      $(@el).html(n.render().el)
    
    n = 0
    for item in @model.equipment.where({etype: 'avionics'})
      n = n + 1
      margin = if (n % 2 == 0) then "30px" else "0px"
      v = new Jetdeck.Views.Avionics.Item(margin: margin, model: item)
      $(@el).append(v.render().el)
    
    
    return this

