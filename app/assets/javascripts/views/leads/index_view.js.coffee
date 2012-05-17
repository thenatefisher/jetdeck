Jetdeck.Views.Leads ||= {}

class Jetdeck.Views.Leads.IndexView extends Backbone.View
  template: JST["backbone/templates/leads/index"]

  initialize: () ->
    @options.leads.bind('reset', @addAll)

  addAll: () =>
    @options.leads.each(@addOne)

  addOne: (lead) =>
    view = new Jetdeck.Views.Leads.LeadView({model : lead})
    @$("tbody").append(view.render().el)

  render: =>
    $(@el).html(@template(leads: @options.leads.toJSON() ))
    @addAll()

    return this
