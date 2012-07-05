Jetdeck.Views.Profile ||= {}

class Jetdeck.Views.Profile.ShowView extends Backbone.View
  template: JST["templates/profile/show"]

  events:
    "click #update_email" : "updateEmail"

  updateEmail: () ->
    profile = new Backbone.Model()
    
    email = @$("input[name='email']").val()
    email_confirmation = @$("input[name='email_confirmation']").val()  
      
    profile.paramRoot = "user"
    profile.attributes.contact = []
    profile.attributes.contact.email = email
    profile.attributes.contact.email_confirmation = email_confirmation    
    window.m = profile
    profile.url = '/users/' + @model.get('id')
    profile.save(
      success: () ->
        console.log "test"
      error: (c, jqXHR) =>
        errObj = $.parseJSON(jqXHR.responseText)            
    )
    return this
    
  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
