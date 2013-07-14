Jetdeck.Views.Profile ||= {}

class Jetdeck.Views.Profile.ShowView extends Backbone.View
  template: JST["templates/profile/show"]
  
  events:
    "click #update-cc"            : "updateCc"
    "click #select-standard-plan" : "selectStandardPlan"
    "click #select-pro-plan"      : "selectProPlan"
    "click #destroy-account"      : "toggleDestroyMessage"
    "click #destroy-confirm"      : "destroy"
    "click .destroy-cancel"       : "toggleDestroyMessage"
    
  destroy: =>
    if @$("#destroy-confirmation-text").val() == "DESTROY MY ACCOUNT"
      @model.destroy({complete: =>
        mixpanel.track("Account Destroyed", ->
          window.location.href = "/"
        )
      })

  toggleDestroyMessage: ->
    @$("#destroy-confirmation-text").html("")
    if $("#destroy-actions").is(":visible")
      $("#destroy-actions").hide()
      $("#destroy-account").show()
    else
      $("#destroy-actions").show()
      $("#destroy-account").hide()
    return false

  selectProPlan: =>
    # set CSRF token
    csrf_token = $("meta[name='csrf-token']").attr("content")
    @$("input[name='authenticity_token']").val(csrf_token)   

    # set plan type
    @$("input[name='plan']").val("PRO")   
    mixpanel.track("Changed Plan", {type: "Pro"})

    if @model.get("card")
      @$('#stripe-profile-form').submit()
      return

    # displays strip window
    StripeCheckout.open({
      key:         @model.get("stripe_key")
      address:     false
      amount:      3900
      currency:    'usd'
      name:        'JetDeck Services, LLC'
      description: 'Pro Account Monthly Subscription'
      panelLabel:  'Select Plan'
      token:        @stripe_token
    })

  selectStandardPlan: =>
    # set CSRF token
    csrf_token = $("meta[name='csrf-token']").attr("content")
    @$("input[name='authenticity_token']").val(csrf_token)   

    # set plan type
    @$("input[name='plan']").val("STANDARD") 
    mixpanel.track("Changed Plan", {type: "Standard"})

    if @model.get("card")
      @$('#stripe-profile-form').submit()
      return

    # displays strip window
    StripeCheckout.open({
      key:         @model.get("stripe_key")
      address:     false
      amount:      2500
      currency:    'usd'
      name:        'JetDeck Services, LLC'
      description: 'Standard Account Monthly Subscription'
      panelLabel:  'Select Plan'
      token:        @stripe_token
    })

  stripe_token: (res) =>
    # set stripe token and makes ajax call
    $input = $('<input type=hidden name=stripeToken />').val(res.id)
    @$('#stripe-profile-form').append($input).submit()

  updateCc: =>
    # set CSRF token
    csrf_token = $("meta[name='csrf-token']").attr("content")
    @$("input[name='authenticity_token']").val(csrf_token)   

    # set plan type
    @$("input[name='plan']").val("") 
    mixpanel.track("Changed Credit Card")

    # displays strip window
    StripeCheckout.open({
      key:         @model.get("stripe_key")
      address:     false
      amount:      0
      currency:    'usd'
      name:        'JetDeck Services, LLC'
      description: 'Update Payment Details'
      panelLabel:  'Update'
      token:        @stripe_token
    })

  render: =>
    storage_usage_in_percent = Math.round(100*(parseInt(@model.get('storage_usage')) / parseInt(@model.get('storage_quota'))))
    airframes_usage_in_percent = Math.round(100*(parseInt(@model.get('airframes')) / parseInt(@model.get('airframes_quota'))))
    storage_usage_style = if (storage_usage_in_percent < 80) then "success" else "warning"
    storage_usage_style = "danger" if (storage_usage_in_percent > 95)
    airframes_usage_style = if (airframes_usage_in_percent < 80) then "success" else "warning"
    airframes_usage_style = "danger" if (airframes_usage_in_percent > 95)

    view_params = {
      storage_usage_in_megs: (parseInt(@model.get('storage_usage')) / 1048576).toFixed(1)
      storage_quota_in_megs: (parseInt(@model.get('storage_quota')) / 1048576).toFixed(1)
      storage_usage_in_percent: storage_usage_in_percent
      storage_usage_style: storage_usage_style
      airframes_usage_in_percent: airframes_usage_in_percent
      airframes_usage_style: airframes_usage_style
    }

    $(@el).html(@template($.extend(view_params,@model.toJSON() )))

    # add payment history
    _.each(@model.get("charges"), (charge) => 
      @$("#paymentHistory tbody").append("<tr><td>"+charge.created+"</td><td>"+charge.amount+"</td><td>"+charge.paid+"</td></tr>")
    )

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
