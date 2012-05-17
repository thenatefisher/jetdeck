class Jetdeck.Routers.LeadsRouter extends Backbone.Router
  initialize: (options) ->
    @leads = new Jetdeck.Collections.LeadsCollection()
    @leads.reset options.leads

  routes:
    "new"      : "newLead"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"        : "index"

  newLead: ->
    @view = new Jetdeck.Views.Leads.NewView(collection: @leads)
    $("#leads").html(@view.render().el)

  index: ->
    @view = new Jetdeck.Views.Leads.IndexView(leads: @leads)
    $("#leads").html(@view.render().el)

  show: (id) ->
    lead = @leads.get(id)

    @view = new Jetdeck.Views.Leads.ShowView(model: lead)
    $("#leads").html(@view.render().el)

  edit: (id) ->
    lead = @leads.get(id)

    @view = new Jetdeck.Views.Leads.EditView(model: lead)
    $("#leads").html(@view.render().el)
