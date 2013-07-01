Jetdeck.Views.Profile ||= {}

class Jetdeck.Views.Profile.ShowView extends Backbone.View
  template: JST["templates/profile/show"]
  
  render: =>
    view_params = {
      usage_in_megs: (parseInt(@model.get('storage_usage')) / 1048576).toFixed(1)
      quota_in_megs: (parseInt(@model.get('storage_quota')) / 1048576).toFixed(1)
      usage_in_percent: Math.round(100*(parseInt(@model.get('storage_usage')) / parseInt(@model.get('storage_quota'))))
    }

    $(@el).html(@template($.extend(view_params,@model.toJSON() )))

    # resend activation email
    @$(".resend").on("click", =>
      $.get("/resend_activation",
        success: =>
          @$("#activation-msg").html("Activation email resent. Please check your inbox for a new email.")
          @$("#activation-msg").removeClass("alert-danger")
          @$("#activation-msg").addClass("alert-success")
      )
    )

    # setup editable fields
    @$('#name').editable({
      title: 'Enter Your Full Name',
      value: {
        first: @model.attributes.contact['first']
        last: @model.attributes.contact['last']
      },
      placement: 'bottom',
      send: 'never',
      url: (obj) => 
        @model.attributes.contact['first'] = obj.value.first
        @model.attributes.contact['last'] = obj.value.last
        @model.save()
    })
    @$('#last').editable({url: (obj) => @model.attributes.contact[obj.name] = obj.value; @model.save()})
    @$('#company').editable({url: (obj) => @model.attributes.contact[obj.name] = obj.value; @model.save()})
    @$('#title').editable({url: (obj) => @model.attributes.contact[obj.name] = obj.value; @model.save()})
    @$('#phone').editable({url: (obj) => @model.attributes.contact[obj.name] = obj.value; @model.save()})
    @$('#signature').editable({url: (obj) => @model.set('signature', obj.value); @model.save()})
    @$('#email').editable({
      url: (obj) =>       
        @model.attributes.contact['email'] = obj.value.email
        @model.attributes.contact['email_confirmation'] = obj.value.email_confirmation
        @model.save()
      error: (response, newValue) =>
        response = JSON.parse(response.responseText)
        msg = response.email || repsonse.email_confirmation if response
        msg = msg[0] if msg
        return msg || "Valid email and confirmation required"
    })
    @$('#password').editable({
      validate: (value) =>
        if $.trim(value.password_confirmation) == ''
          return 'Confirmation is required'
      error: (response, newValue) =>
        response = JSON.parse(response.responseText)
        msg = response.password || repsonse.password_confirmation if response
        msg = msg[0] if msg
        return msg || "Password and confirmation required"           
      url: (obj) =>       
        @model.attributes.contact['password'] = obj.value.password
        @model.attributes.contact['password_confirmation'] = obj.value.password_confirmation
        @model.save()
    })
    @$('#website').editable({
      url: (obj) => 
        website = obj.value.replace(/http\:\/\//, '')
        website = 'http://' + website
        @model.attributes.contact[obj.name] = website
        @model.save()
      error: (response, newValue) =>
        response = JSON.parse(response.responseText)
        msg = response.website response
        msg = msg[0] if msg
        return msg || "Valid URL required"        
      success: (response, newValue) =>
        return {newValue: response.website}
    })    

    return this
