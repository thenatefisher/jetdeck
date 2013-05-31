Jetdeck.Views.Leads ||= {}

class Jetdeck.Views.Leads.LeadView extends Backbone.View
  template : JST["templates/airframes/leads/item"]
  
  tagName : "tr"
  
  events:
    "click .xspec_settings"         : "xspecSettings"
    "click .remove_xspec"           : "removeSpec"

  initialize: =>
    $(@el).hover(
      => $(".lead_buttons", @el).children().show(),
      => $(".lead_buttons", @el).children().hide(),
    )

  removeSpec: =>
    confirmDelete = new Jetdeck.Views.Leads.DestroyView(model: @model)
    modal(confirmDelete.render().el)
    return this  
    
  xspecSettings: =>
    specModel = new Jetdeck.Models.SpecModel()
    specModel.url = "/xspecs/" + @model.get('xspec_id')
    specModel.fetch(
        success: (xspecModel) ->
            specView = new Jetdeck.Views.Spec.EditView(model: xspecModel)
            modal(specView.render().el)    
    )
    return this
      
  render : ->
    $(@el).html(@template(@model.toJSON() ))
    return this       
