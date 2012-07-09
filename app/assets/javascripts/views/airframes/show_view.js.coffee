Jetdeck.Views.Airframes ||= {}

class Jetdeck.Views.Airframes.ShowView extends Backbone.View
  template: JST["templates/airframes/show"]

  initialize : =>
    return this

  render: =>
  
    $(@el).html(@template(@model.toJSON() ))

    @widgets ||= {}
    
    @widgets.header = new Jetdeck.Views.Airframes.ShowHeader(model: @model)
    @$("#airframe_show_header").html(@widgets.header.render().el)

    @widgets.spec = new Jetdeck.Views.Airframes.ShowSpec(model: @model)
    @$("#airframe_spec_details").html(@widgets.spec.render().el)
    
    @widgets.send = new Jetdeck.Views.Airframes.ShowSend(model: @model)
    @$("#airframe_send").html(@widgets.send.render().el)

    if @model.leads.length > 0
      @widgets.leads = new Jetdeck.Views.Airframes.ShowLeads(model: @model)
      @$("#airframe_leads").html(@widgets.leads.render().el)

    return this
    
