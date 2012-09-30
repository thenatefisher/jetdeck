Jetdeck.Views.Profile ||= {}

class Jetdeck.Views.Profile.ShowView extends Backbone.View
  template: JST["templates/profile/show"]

  events:
    "click #upload"           : "chooseLogo"
    "keydown .inline-edit"    : "edit"
    "change #logo"            : "showSelectedFile"
    "click #delete"           : "deleteLogo"
   
  deleteLogo: (e) =>
     e.preventDefault()
     $.ajax(
       url: "/user_logos/1", 
       type: "DELETE", 
       success: =>
          @model.set('logo', null)
          window.router.show()
          mixpanel.track("Deleted Logo")  
     )
     
  showSelectedFile: (event) ->
    e = event.target || event.currentTarget
    fileString = $(e).val()
    
    if fileString.length > 15
      fileString = "..." + fileString.substr(fileString.length - 15, 15)
      
    @$("#logo-help").html(fileString)
    $("#changes").children().fadeIn()
    $("#changes").slideDown()
    
  chooseLogo: ->
    @$("#logo").click()

  initialize: =>
    $("#cancel-changes").on("click", @cancel)
    $("#save-changes").on("click", @save)
    
  cancel: =>
    $("#changes").children().fadeOut()
    $("#changes").slideUp(=>
      @model.fetch( success: ->
        window.router.view.render()
      )
    )
    
  edit: (event) ->
    element = event.target || event.currentTarget 
    $(element).addClass("changed")
    $("#changes").children().fadeIn()
    $("#changes").slideDown()
  
  save: (e) =>
    mixpanel.track("Updated Profile")  
    $("#save-changes").prop('disabled', true)
    $(".error").html("")
    self = this
    
    @model.set('spec_disclaimer', @$("textarea[name='spec_disclaimer']").val())
    
    $(".inline-edit").each( ->
      
      # strip leading/trailing space
      this.value = this.value.replace(/(^\s*)|(\s*$)/gi,"")
      this.value = this.value.replace(/\n /,"\n")
      self.model.attributes.contact[this.name] = this.value

    )
    
    # add protocol onto website url
    website = @model.attributes.contact['website']
    website = website.replace(/http\:\/\//, '')
    website = 'http://' + website
    @model.attributes.contact['website'] = website

    @model.save(null,
      success: (response) =>
        $("#changes").children().fadeOut()
        $("#changes").slideUp(=>
          window.router.view.render()
          alertSuccess("<i class='icon-ok icon-large'></i> Changes Saved!") 
        )
        if $("#logo").val() != ""
          $("form").submit()

      error: (model, error) =>
        alertFailure(
          "<i class='icon-warning-sign icon-large'></i> Error Saving Changes"
        )
        errorStruct = JSON.parse(error.responseText)      
        $(".error[for='"+e+"']").html(errorStruct[e].toString()) for e of errorStruct

    )
    
    $("#save-changes").prop('disabled', false)
    
  updateEmail: ->
    email = @$("input[name='email']").val()
    email_confirmation = @$("input[name='email_confirmation']").val()  
    @model.attributes.contact.email = email
    @model.attributes.contact.email_confirmation = email_confirmation    

    @model.save(null,
      success: () ->
            $('.email-failure').hide()   
            $('.email-confirmation').val('')
      error: (c, jqXHR) =>
            errObj = $.parseJSON(jqXHR.responseText)  
            if errObj.email[0]  
                alertFailure("Email " + errObj.email[0])       
    )
    return this
    
  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
