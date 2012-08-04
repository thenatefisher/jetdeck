Jetdeck.Views.Leads ||= {}

class Jetdeck.Views.Leads.DestroyView extends Backbone.View
  template : JST["templates/airframes/leads/confirm_delete"]
  
  tagName: "div"
  
  events:
    "click .confirm_remove_lead"    : "confirmRemoveLead"
    
  confirmRemoveLead: () =>
    xid = @model.get('xspecId')
    @model.url = "/xspecs/" + xid
    @model.destroy()
    window.router.view.leads.render()
    modalClose()
    return this
    
  render : ->
    $(@el).html(@template(@model.toJSON() ))
    return this   
