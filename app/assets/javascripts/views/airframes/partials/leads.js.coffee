Jetdeck.Views.Airframes.Leads ||= {}

class Jetdeck.Views.Airframes.Leads.Show extends Backbone.View
  template: JST["templates/airframes/leads/leads"]

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
        view = new Jetdeck.Views.Airframes.Leads.Item({model : lead})
        @$("#leads-populated").append(view.render().el) if view
      )

    return this

class Jetdeck.Views.Airframes.Leads.Item extends Backbone.View
  template: JST["templates/airframes/leads/lead_item"]

  render: =>
    $(@el).html(@template(@model.toJSON() ))

    @$('.collapse').on('hidden', =>
      @$('.accordion-toggle').html("<i class='icon-caret-right'></i>")
    )
    @$('.collapse').on('shown', =>
      @$('.accordion-toggle').html("<i class='icon-caret-down'></i>")
    )

    return this

