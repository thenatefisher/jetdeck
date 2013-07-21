Jetdeck.Views.Contacts.Leads ||= {}

class Jetdeck.Views.Contacts.Leads.Show extends Backbone.View
  template: JST["templates/contacts/leads/leads"]

  refresh: =>
    @model.fetch(success: =>
      @model.updateChildren()
      @render()
      )

  render: =>
    if @model.leads.length > 0
      # render out main template
      $(@el).html(@template(@model.toJSON()))
      @model.leads.each((lead) =>  
        view = new Jetdeck.Views.Contacts.Leads.Item({model : lead})
        @$("#leads-populated table").append(view.render().el) if view
      )

    return this

class Jetdeck.Views.Contacts.Leads.Item extends Backbone.View
  template: JST["templates/contacts/leads/lead_item"]

  tagName: "tr"

  render: =>
    $(@el).html(@template(@model.toJSON() ))

    return this

