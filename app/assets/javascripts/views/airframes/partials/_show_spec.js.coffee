Jetdeck.Views.Airframes ||= {}

class Jetdeck.Views.Airframes.ShowSpec extends Backbone.View
  template: JST["templates/airframes/partials/_specDetails"]

  events:
    "click .addEquipment"       : "add"

  add: () =>
    newEquipment = new Jetdeck.Views.Airframes.AddEquipmentModal(model: @model, parent: this)
    newEquipment.modal()
    
  render: ->
    # load the tabs container
    $(@el).html(@template(@model.toJSON() ))

    # populate engines tab
    @engines = new Jetdeck.Views.Airframes.ShowEnginePane(model: @model)
    @$("#pane_engines").html(@engines.render().el)

    # populate avionics tab
    @avionics = new Jetdeck.Views.Airframes.ShowSpecPane(type: 'avionics', model: @model)
    @$("#pane_avionics").html(@avionics.render().el)

    # populate cosmetics tab
    @cosmetics = new Jetdeck.Views.Airframes.ShowSpecPane(type: 'cosmetics', model: @model)
    @$("#pane_cosmetics").html(@cosmetics.render().el)

    # populate the equipment tab
    @equipment = new Jetdeck.Views.Airframes.ShowSpecPane(type: 'equipment', model: @model)
    @$("#pane_equipment").html(@equipment.render().el)

    # remove top border on first table item in spec panes
    @$(".spec_pane table").children('tbody').children('tr').first().children('td').css('border-top', '0px')

    # trashcan icon visible on hover
    @$(".equipmentTooltip").hover(
      ->
        $(this).children('.removeEquipment').css('visibility', 'visible')
      ->
        $(this).children('.removeEquipment').css('visibility', 'hidden')
    )

    return this

