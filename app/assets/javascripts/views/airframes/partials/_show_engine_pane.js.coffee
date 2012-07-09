Jetdeck.Views.Airframes ||= {}

# This is a pane inside the specification tab container
# and only displays engines
class Jetdeck.Views.Airframes.ShowEnginePane extends Backbone.View
  template: JST["templates/equipment/engine_pane"]

  events:
    "click .remove_engine"    : "destroy"
    "change .inline-edit"     : "edit"
    "click .copy_engine"      : "copy"
    "click .add_engine"       : "add"

  edit: (event) ->
    e = event.target || event.currentTarget
    engineId = $(e).data('eid')
    
    if $(e).hasClass('number')
      value = parseInt($(e).val().replace(/[^0-9]/g,""), 10)
      $(e).val(value.formatMoney(0, ".", ","))
    else
      value = $(e).val()

    name = $(e).attr('name')
    
    @model.engines.get(engineId).set(name, value)
    @model.engines.get(engineId).save()
  
  copy: (event) ->
    e = event.target || event.currentTarget
    engineId = $(e).data('eid')
    
    newEngine = new Jetdeck.Models.EngineModel()
    newEngine.attributes = @model.engines.get(engineId).attributes
    newEngine.attributes.airframe_id = @model.id
    newEngine.attributes.id = null

    @model.engines.on("add", @render)
    @model.engines.create(newEngine.toJSON())    
    return
  
  add: () =>
    newEquipment = new Jetdeck.Views.Airframes.AddEquipmentModal(type: "engines", model: @model, parent: this)
    newEquipment.modal()
    return

  destroy: (event) ->
    e = event.target || event.currentTarget
    engineId = $(e).data('eid')
    @model.engines.get(engineId).destroy(
        success: =>
           @render()
    )
    return 
    
  render: =>
    $(@el).html(@template(engineItems: @model.engines.toJSON() ))

    @$(".number").each(->
        if $(this).val() != null
          intPrice = parseInt($(this).val().replace(/[^0-9]/g,""), 10)
          $(this).val(intPrice.formatMoney(0, ".", ","))
    )    
    
    return this
