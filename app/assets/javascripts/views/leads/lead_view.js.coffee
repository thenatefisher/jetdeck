Jetdeck.Views.Leads ||= {}

class Jetdeck.Views.Leads.LeadView extends Backbone.View
  template: JST["backbone/templates/leads/lead"]

  events:
    "click .destroy" : "destroy"

  tagName: "tr"

  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
