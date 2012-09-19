Jetdeck.Views.Airframes ||= {}

# This is a pane inside the specification tab container
# and only displays engines
class Jetdeck.Views.Airframes.ShowEnginePane extends Backbone.View
  template: JST["templates/airframes/spec/engines/pane"]

  events:
    "keyup .engine_inline_edit"      : "edit"
    "click .add_engine"                : "add"
    "click .remove_engine"             : "destroy"
    
  edit: (event) =>
    e = event.target || event.currentTarget
    engineId = $(e).data('eid')
    
    if $(e).hasClass('number')
      value = parseInt($(e).val().replace(/[^0-9]/g,""), 10)
      $(e).val(value.formatMoney(0, ".", ","))
    else
      value = $(e).val()

    name = $(e).attr('name')
    
    $(e).addClass('changed')
    @model.engines.getByCid(engineId).set(name, value)
    window.router.view.edit()
  
  add: =>
    @render()
    window.router.view.edit()
    
  destroy: (event) =>
    e = event.target || event.currentTarget
    engineId = $(e).data('eid')
    engine = @model.engines.getByCid(engineId)

    if !engine.get("pending")
      engine.destroy(
          success: =>
             window.router.view.spec.engines.render()
      )
    else
      @model.engines.remove(engine)
      @model.set('engines', @model.engines.toJSON())
      window.router.view.spec.engines.render()
    
  render: =>
    
    @model.engines.each( (m) -> m.set('cid', m.cid))  
  
    $(@el).html(@template(engineItems: @model.engines.toJSON() ))

    @$("input[name='engine']").select2({
      placeholder: "i.e. PT6A-114 (Pratt and Whitney)",
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
        m = new Jetdeck.Models.EngineModel(
          id: id
          model_name: model_name
          pending: true
        )
        m.set('cid', m.cid)
        @model.engines.add(m)
        @model.set('engines', @model.engines.toJSON())
    )
    return this
