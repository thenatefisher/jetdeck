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
    if @model.get('history')
      element = @$('#chartContainer')
      chart = new Highcharts.Chart(
        chart: 
          renderTo: element[0]
          type: 'line'
          width: 450
          height: 130
        title:
          text: null
        tooltip: 
          formatter: ->
             d = new Date(this.x)
             dateString = d.getMonth() + "-" + d.getDate() + "-" + d.getFullYear()
             return "<strong>" + this.y + " views </strong><br>" + dateString
        yAxis:
          title:
            text: null
          min: 0
        xAxis:
          type: 'datetime'
          maxZoom: 48 * 3600 * 1000
          labels:
            step: Math.floor(@model.get('history').data.length / 4)
        legend:
          enabled: false
        series: [{
          data: [2,12,4,15,7,11,4,24,17,24]
          pointStart: parseInt(@model.get('history').start)*1000
          pointInterval: 24 * 3600 * 1000        
        }]
      )
    
    @$("form").backboneLink(@model)
    
    return this
