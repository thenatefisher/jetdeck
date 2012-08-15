Jetdeck.Views.Airframes ||= {}

# This is a pane inside the specification tab container
# and only displays engines
class Jetdeck.Views.Airframes.ShowEnginePane extends Backbone.View
  template: JST["templates/airframes/spec/engines/pane"]

  events:
    "click .remove_engine"            : "destroy"
    "change .engine_inline_edit"      : "edit"
    "click .copy_engine"              : "copy"
    "click .add_engine"               : "add"

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
  
  add: =>
    
    collection = new Jetdeck.Collections.AirframesCollection()
    collection = window.router.airframes if window.router.airframes
    collection.create(@model.toJSON(),
      success: (airframe) =>
        @model = airframe
        window.router.view.spec.engines.render()

      error: (airframe, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  destroy: (event) ->
    e = event.target || event.currentTarget
    engineId = $(e).data('eid')
    @model.engines.get(engineId).destroy(
        success: =>
           window.router.view.spec.engines.render()
    )
    return 
    
  render: =>
    $(@el).html(@template(engineItems: @model.engines.toJSON() ))

    @$("input[name='engine']").select2({
      placeholder: "PT6A-114 (Pratt and Whitney)",
      minimumInputLength: 3,
      createSearchChoice: (term) ->
        return { id: "0", text: term }
      ajax: {
        url: "/engines.json",
        dataType: "json",
        quietMillis: 100,
        data: (term, page) ->
          return { q: term }
        results: (data) ->
          return { results: data }
      }
    }).change( (e) =>
        event = e.target || e.currentTarget
        id = $(event).val()
        model_name = $("div.engine-selection a span").html()
        m = new Jetdeck.Models.EngineModel({id: id, model_name: model_name})
        @model.engines.add(m)
        @model.set('engines', @model.engines.toJSON())
    )
    return this
