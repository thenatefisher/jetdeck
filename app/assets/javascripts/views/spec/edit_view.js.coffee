Jetdeck.Views.Spec ||= {}

class Jetdeck.Views.Spec.EditView extends Backbone.View
  template: JST["templates/airframes/leads/edit"]

  events:
    "click #xspec_save" : "update"

  update : (e) ->
    e.preventDefault()
    e.stopPropagation()
    
    @$("input@[type='checkbox']").each( (i, element) =>
      if $(element).is(":checked") 
        @model.set($(element).attr("name"), "true")
      else 
        @model.set($(element).attr("name"), "false")
    )
    
    @model.save(null,
      success : (xspec) =>
        @model = xspec
        modalClose()
    )

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    element = @$('#chartContainer')
    chart = new Highcharts.Chart(
      chart: 
        renderTo: element[0],
        type: 'line',
        width: 450,
        height: 130
      title:
        text: null
      yAxis:
        title:
          text: null
        min: 0
      legend:
        enabled: false
      series: [{
        data: [222]
      }]
    )
    
    @$("form").backboneLink(@model)
    
    return this
