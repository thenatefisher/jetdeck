Jetdeck.Views.Engines ||= {}

class Jetdeck.Views.Engines.AddModalItem extends Backbone.View
  template: JST["templates/airframes/spec/engines/item"]

  render : ->
    $(@el).html(@template(@model.toJSON() ))
    return this

class Jetdeck.Views.Engines.AddModal extends Backbone.View
  template: JST["templates/airframes/spec/engines/new"]

  render : =>
    collection = new Jetdeck.Collections.EnginesCollection()
    collection.fetch(
        success: (engines) =>
            $(@el).html(@template() )
            engines.each((item) =>
                view = new Jetdeck.Views.Engines.AddModalItem(model: item)
                @$("#avail-parts").append(view.render().el)
            )
            @$('#equipment-form').multiSelect({
              selectableHeader : '<input type="text" class="input-large" id="equipment-search" autocomplete = "off" />',
              selectedHeader : '<h4 style="background: #eee; margin-bottom: 5px; padding: 7px 10px;">Selected Equipment</h4>',
              afterSelect : @addEngine,
              afterDeselect : @removeEngine
            })

            @$('input#equipment-search').quicksearch('#ms-equipment-form .ms-selectable li')                       
    )
    return this

  removeEngine : (e) =>
    @model.equipment.remove(e)
    @model.save(null,
        success: =>
            @model.fetch( success: => @options.parent.render())
    )

  addEngine : (e) =>
    m = new Jetdeck.Models.EngineModel({id: e})
    @model.engines.add(m)
    @model.set('engines', @model.engines.toJSON())
    @model.save(null,
        success: =>
            @model.fetch( success: => @options.parent.render())
    )

  modal : =>
    modal(@render().el)
    return this
