Jetdeck.Views.Airframes ||= {}

class Jetdeck.Views.Airframes.ShowSpec extends Backbone.View
  template: JST["templates/airframes/partials/spec"]

  render: ->
    # load the tabs container
    $(@el).html(@template(@model.toJSON() ))

    # populate airframe tab
    @airframe = new Jetdeck.Views.Airframes.ShowAirframePane(model: @model)
    @$("#pane_airframe").html(@airframe.render().el)
    
    # populate engines tab
    @engines = new Jetdeck.Views.Airframes.ShowEnginePane(model: @model)
    @$("#pane_engines").html(@engines.render().el)

    # populate avionics tab
    @avionics = new Jetdeck.Views.Airframes.ShowAvionicsPane(model: @model)
    @$("#pane_avionics").html(@avionics.render().el)

    # populate description tab
    @description = new Jetdeck.Views.Airframes.ShowDescriptionPane(model: @model)
    @$("#pane_description").html(@description.render().el)

    # populate the equipment tab
    @equipment = new Jetdeck.Views.Airframes.ShowEquipmentPane(model: @model)
    @$("#pane_equipment").html(@equipment.render().el)

    # remove top border on first table item in spec panes
    @$(".spec_pane table").children('tbody').children('tr').first().children('td').css('border-top', '0px')

    return this

