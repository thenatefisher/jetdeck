Jetdeck.Views.Contacts ||= {}
   
class Jetdeck.Views.Contacts.CustomDetailItem extends Backbone.View
  template: JST["templates/contacts/partials/custom_detail_item"]
  
  events:
    "click .detail-delete"  : "destroy" 
    "change input"          : "edit" 
    
  tagName: "tr"
  
  edit: (event) =>
    e = event.target || event.currentTarget
    value = $(e).val()
    name = $(e).attr("name")
    $(e).addClass("changed")
    window.router.view.model.custom_details.getByCid(@model.cid).set(name, value)
    window.router.view.edit()
    
  destroy : =>
    if !@model.get("pending")
        @model.destroy(success: => 
          mixpanel.track("Deleted Contact Detail")
        )    
    else
      window.router.view.model.custom_details.remove(@model)
    window.router.view.header.render()
    
  initialize: ->
    $(@el).hover( 
      => @$(".buttons").show(),
      => @$(".buttons").hide()
    )
  
  render : =>
    $(@el).html(@template(@model.toJSON() ))
    return this
  

