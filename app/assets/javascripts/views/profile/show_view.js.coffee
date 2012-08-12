Jetdeck.Views.Profile ||= {}

class Jetdeck.Views.Profile.ShowView extends Backbone.View
  template: JST["templates/profile/show"]

  events:
    "click #update_email" : "updateEmail"
    "change .inline-edit" : "edit"

  edit: (e) ->
    value = $(e.target).val()
    name = $(e.target).attr('name')
    @model.attributes.contact[name] = value
    @model.save(null)
    
  updateEmail: () ->    
    email = @$("input[name='email']").val()
    email_confirmation = @$("input[name='email_confirmation']").val()  
    @model.attributes.contact.email = email
    @model.attributes.contact.email_confirmation = email_confirmation    

    @model.save(null,
      success: () ->
            $('.email-failure').hide()   
            $('.email-confirmation').val('')
            alertSuccess("Email Address Updated!") 
      error: (c, jqXHR) =>
            errObj = $.parseJSON(jqXHR.responseText)  
            if errObj.email[0]  
                alertFailure("Email " + errObj.email[0])       
    )
    return this
    
  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
