Jetdeck.Views.Contacts ||= {}

class Jetdeck.Views.Contacts.CustomDetailItem extends Backbone.View
  template: JST["templates/contacts/partials/custom_detail_item"]
  
  events: 
    "click .detail-delete"        : "destroy"
  
  tagName: "tr"
  
  destroy: =>
    @model.destroy(success: => 
      mixpanel.track("Deleted Contact Detail")
    )

  initialize: ->
    $(@el).hover( 
      => @$(".buttons").show(),
      => @$(".buttons").hide()
    )
  
  render : =>
    $(@el).html(@template(@model.toJSON() ))
    return this
  

