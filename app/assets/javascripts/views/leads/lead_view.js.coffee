Jetdeck.Views.Leads ||= {}

class Jetdeck.Views.Leads.LeadView extends Backbone.View
  template : JST["templates/airframes/partials/_lead_entry"]
  
  tagName : "tr"
  
  events:
    "click .xspec_settings"         : "xspecSettings"
    "click .remove_xspec"           : "removeSpec"

  removeSpec: () =>
    confirmDelete = new Jetdeck.Views.Leads.DestroyView(model: @model)
    modal(confirmDelete.render().el)
    return this  
    
  xspecSettings: () =>
    window.test = @model
    specModel = new Jetdeck.Models.Spec()
    specModel.url = "/xspecs/" + @model.get('xspecId') + "/edit"
    specModel.fetch(
        success: (xspecModel) ->
            specView = new Jetdeck.Views.Spec.EditView(model: xspecModel)
            modal(specView.render().el)    
    )
    return this
      
  render : ->
    $(@el).html(@template(@model.toJSON() ))
    return this       
