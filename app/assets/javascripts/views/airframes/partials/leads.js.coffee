Jetdeck.Views.Airframes.Leads ||= {}

class Jetdeck.Views.Airframes.Leads.Show extends Backbone.View
  template: JST["templates/airframes/leads/leads"]

  events:
    "click .toggle-fold" : "toggleFold"

  toggleFold: =>
    if @$(".fold").first().is(":hidden")
      @$(".fold").show()
      @$(".toggle-fold").html("(less)")
    else
      @$(".fold").hide()
      @$(".toggle-fold").html("(more)")

  refresh: =>
    @model.fetch(success: =>
      @model.updateChildren()
      @render()
      )

  render: =>
    if @model.leads.length > 0
      # hide these on load
      fold_limit = 4
      # render out main template
      $(@el).html(@template(@model.toJSON()))
      @model.leads.each((lead, index) =>  
        view = new Jetdeck.Views.Airframes.Leads.Item({model : lead, fold: (index > fold_limit - 1)})
        @$("#leads-populated").append(view.render().el) if view
      )

      if @model.leads.length > fold_limit
        @$("#leads-populated").append("<a href='#' class='toggle-fold muted pull-right' style='margin: -5px 0 10px 0'>(more)</a>")

    return this

class Jetdeck.Views.Airframes.Leads.Item extends Backbone.View
  template: JST["templates/airframes/leads/lead_item"]

  render: =>
    params = {fold: @options.fold}
    $(@el).html(@template($.extend(@model.toJSON(), params)))

    @$('.collapse').on('hidden', =>
      @$('.accordion-toggle').html("<i class='icon-caret-right'></i>")
    )
    @$('.collapse').on('shown', =>
      @$('.accordion-toggle').html("<i class='icon-caret-down'></i>")
    )

    return this

