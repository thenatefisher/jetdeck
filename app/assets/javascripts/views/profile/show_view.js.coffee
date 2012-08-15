Jetdeck.Views.Profile ||= {}

class Jetdeck.Views.Profile.ShowView extends Backbone.View
  template: JST["templates/profile/show"]

  events:
    "click #update_password"  : "updatePassword"
    "click #update_email"     : "updateEmail"
    "click #upload"           : "chooseLogo"
    "change .inline-edit"     : "edit"
    "change #logo"            : "showSelectedFile"

  updatePassword: =>
    passwd = @$("input[name='new_password']").val()
    passwd_confirmation = @$("input[name='new_password_confirmation']").val()  
    @model.attributes.password = passwd
    @model.attributes.password_confirmation = passwd_confirmation    

    @model.save(null,
      success: () =>
            $('.password-failure').hide()   
            @$("input[name='new_password']").val('')
            @$("input[name='new_password_confirmation']").val('') 
            alertSuccess("Password Updated!") 
            delete @model.attributes.password
            delete @model.attributes.password_confirmation
            window.t = @model 
      error: (c, jqXHR) =>
            errObj = $.parseJSON(jqXHR.responseText)  
            if errObj.password[0]  
                alertFailure("Password " + errObj.password[0])  
            delete @model.attributes.password
            delete @model.attributes.password_confirmation
            window.t = @model                      
    )

    return this
      
  showSelectedFile: (event) ->
    e = event.target || event.currentTarget
    fileString = $(e).val()
    
    if fileString.length > 15
      fileString = "..." + fileString.substr(fileString.length - 15, 15)
      
    @$("#upload").html(fileString)
  
  chooseLogo: ->
    @$("#logo").click()

  edit: (e) ->
    value = $(e.target).val()
    name = $(e.target).attr('name')
    @model.attributes.contact[name] = value
    @model.save(null)
    
  updateEmail: ->    
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
