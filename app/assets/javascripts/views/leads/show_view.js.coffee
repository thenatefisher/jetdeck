Jetdeck.Views.Leads ||= {}

class Jetdeck.Views.Leads.ShowView extends Backbone.View
  template: JST["backbone/templates/leads/show"]

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
