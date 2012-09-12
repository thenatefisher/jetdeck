Jetdeck.Views.Airframes ||= {}

# This is a pane inside the specification tab container
## model: AirframeModel
class Jetdeck.Views.Airframes.ShowAvionicsPane extends Backbone.View
  template: JST["templates/airframes/spec/avionics/pane"]

  events:
    "click .add-equipment"         : "addEquipment"

  addEquipment : =>
    @model.equipment.add(
        title: $(".equipment-title", @el).val().toUpperCase()
        name: $(".equipment-name", @el).val()
        etype: 'avionics'
        pending: true
    )
    @render()
    window.router.view.edit()
    
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

