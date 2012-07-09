Jetdeck.Views.Leads ||= {}

class Jetdeck.Views.Leads.LeadView extends Backbone.View
  template : JST["templates/airframes/partials/_lead_entry"]
  
  tagName : "tr"
  
  events:
    "click .xspec_settings"             : "xspecSettings"
    "click .remove_xspec"           : "removeSpec"

  removeSpec: () =>
    confirmDelete = new Jetdeck.Views.Airframes.EntryDestroy(model: @model)
    modal(confirmDelete.render().el)
    return this  
    
  xspecSettings: () ->
    specModel = new Jetdeck.Models.Spec(id: n)
    specModel.fetch(
        success: () ->
            specView = new Jetdeck.Views.Spec.EditView(model: this)
            modal(specView.render())    
    )
    return this
      
  render : ->
    $(@el).html(@template(@model.toJSON() ))
    return this       
