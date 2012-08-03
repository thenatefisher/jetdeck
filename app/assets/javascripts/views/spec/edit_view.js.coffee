Jetdeck.Views.Spec ||= {}

class Jetdeck.Views.Spec.EditView extends Backbone.View
  template: JST["templates/airframes/leads/edit"]

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
        data: [2,15,7,0,3,5,0,2,1]
      }]
    )
    return this
