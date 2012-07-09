Jetdeck.Views.Airframes ||= {}

# This is a pane inside the specification tab container
# The SpecPaneView doesn't display engines
class Jetdeck.Views.Airframes.ShowSpecPane extends Backbone.View
  template: JST["templates/equipment/spec_pane"]

  events:
    "click .removeEquipment"    : "destroy"

  destroy: (event) ->
    e = event.target || event.currentTarget
    equipmentId = $(e).data('eid')

    @model.equipment.remove(equipmentId)
    @model.save(null,
        success: =>
            @render()
    )

  render: =>
    data = Array()
    @model.equipment.forEach((i) =>
        if i.get('type') == @options.type
            data.push(i.toJSON())
    )
    $(@el).html(@template(equipmentItems: data ))
    return this
